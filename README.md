# Yatm (Yet Another Tailwind Merge)

[![Module Version](https://img.shields.io/hexpm/v/yatm.svg)](https://hex.pm/packages/yatm)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/yatm)

> A Tailwind class merging utility.

> [!WARNING]  
> This project is currently in an experimental proof-of-concept stage. It's
> still taking shape and many Tailwind features are not yet supported. You're
> welcome to try it out and encouraged to share your feedback, but don't expect
> it to serve your production needs just yet.

## Installation and usage

Add `yatm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:yatm, "~> 0.1.0"}
  ]
end
```

Wherever you potentially need to resolve Tailwind class conflicts, call the
`merge/1` function like so:

```elixir
def button(assigns) do
  ~H"""
  <button type={@type} class={merge([button_classes(), @class])} {@rest}>
    {render_slot(@inner_block)}
  </button>
  """
end
```

## The Tailwind utility conflict problem

When using Tailwind with component abstractions, it's not uncommon for the
authors of components to provide some basic styling out of the box and for
users of those components to want to override some (but not all) of those
classes.

Without a Tailwind class merging utility, component authors usually choose to
either fully overwrite their out of the box classes or just append the classes
supplied by the user to the ones provided in the component. See, for example,
the [button
component](https://github.com/phoenixframework/phoenix/blob/183eb76a88874729cdd5642da03ad7cebd3fa6d3/installer/templates/phx_web/components/core_components.ex#L164)
included in new Phoenix projects:

```elixir
def button(assigns) do
  ~H"""
  <button type={@type} class={[button_classes(), @class]} {@rest}>
    {render_slot(@inner_block)}
  </button>
  """
end
```

If the user provides some additional classes with the `@class` attribute, these
will get appended to the existing ones. This can very easily lead to [class
conflicts](https://tailwindcss.com/docs/styling-with-utility-classes#conflicting-utility-classes).

For example, if the user were to supply a `text-xl` class, there's no guarantee
(in the general case) that Tailwind will build a CSS file where the `text-xl`
is declared after the `text-sm` class (i.e. overriding the `font-size` property
with the CSS cascade). If it did, this might still be a problem if a `text-sm`
were intended to override a `text-xl` somewhere else in the codebase.

This is the problem that a Tailwind class merging utility is designed to
address. It works by parsing the list of concatenated classes and using
knowledge of the CSS properties targeted by each Tailwind utility class to
remove classes that are meant to be overriden by conflicting classes appearing
later in the string.

Calling `Yatm.merge("text-sm text-xl")` will return `"text-xl"` and calling
`Yatm.merge("text-xl text-sm")` will return `"text-sm"`.

## Roadmap and vision

### Finish the `merge` utility

The first milestone is to finish building a `merge/1` function that can take
the same inputs as the regular `class` attribute in HEEx templates–a binary or
a list of binaries with nil and false values being discarded.

### Concerns about (re)compilation

I'm currently implementing this using
[nimble_parsec](https://hex.pm/packages/nimble_parsec). I'm concerned that
compiling the parser is taking on the order of dozens of seconds and the
resulting BEAM file is in the MBs. If this compilation only needs to run once,
that could be fine.

The problem is that the implementation will eventually have to take into
account the user's custom Tailwind theme, which could add new utility classes.
If the theme changes, then maybe that results in a parser recompilation, which
is not ideal.

I still need to explore the space of solutions and problems that might arise as
the implementation develops.

### Concerns about runtime performance

My knowledge of the Phoenix rendering pipeline has some gaps but, as far as I
can tell, the code above would have to run the merge on every template
re-render.

Maybe the run time of the function is so small that there's not a big reason to
try to optimize it away but I'm not sure at this moment, I'd like to do some
benchmarking at some point.

Other libraries memoize these computations. For example,
[tw_merge](https://hex.pm/packages/tw_merge), which was forked from
[turboprop](https://hex.pm/packages/turboprop), requires adding a cache process
to your supervision tree.

Turboprop's merge utility seems to have been implemented as a port of
[tailwind-merge](https://github.com/dcastil/tailwind-merge), the canonical
Tailwind merge utility in the JavaScript ecosystem, which itself implements an
[LRU
cache](https://github.com/dcastil/tailwind-merge/blob/f4eacb6bc1800031147a153fcf20e586b277320e/src/lib/lru-cache.ts).

It could be that I'm just too early in my Elixir journey, but the idea of
adding a process to the supervision tree just to merge strings together doesn't
feel super enticing. Could we find a better solution? Read on!

### Building a custom EEx engine

What if the templating engine was able to do this Tailwind class merging
itself? No need to manually call the `merge` function every time. EEx provides
the [Engine behaviour](https://hexdocs.pm/eex/EEx.Engine.html) to enable this
kind of extension. As far as I understand, EEx templates are usually used in a
way in which they're precompiled, so maybe there's a way to "memoize" these
(maybe expensive) class merging operations within the templates themselves.

If a component's class attribute takes a list of static string values known at
compile-time, we could run the merge and just inline the result into the
compiled template code, resulting in zero run-time cost.

If there's some run-time logic that makes the class value dynamic, it might
still be possible to transform the code and precompute the necessary merge
operations at compile-time. For example, the code `class={["p-1 text-sm", if
some_condition, do: "text-xl", else: "text-2xl"]}` could be transformed into
something like `class={if some_condition, do: "p-1 text-xl", else: "p-1
text-2xl"}` so the minimum amount of work is left to be done at run-time.

We get the best of both worlds: no run-time cost (not even for cache misses)
and no extra cache process and the latency, jitter and memory footprint that
could potentially have. The API is also better as merging happens without
having to call the merge utility explicitly every time, the template engine
just takes care of it according to a config value. The cost would be larger
compile times, obviously.

### Integrating into Phoenix?

Wouldn't it be great if Phoenix shipped with this functionality out of the box?
I think so. Given that Tailwind is so commonly used, it'd be nice to have
Tailwind class merging as one of the features of the templating engine shipped
with Phoenix. I assume there'd be an easy way to switch this feature on and off
so that projects not using Tailwind wouldn't have to pay the compilation price.

## Other Tailwind-related packages

- [tailwind](https://hex.pm/packages/tailwind).
- [tailwind_merge](https://hex.pm/packages/tailwind_merge).
- [twix](https://hex.pm/packages/twix).
- [tw_merge](https://hex.pm/packages/tw_merge).
- [tailwind_formatter](https://hex.pm/packages/tailwind_formatter).
- [tails](https://hex.pm/packages/tails).
- [turboprop](https://hex.pm/packages/turboprop).

