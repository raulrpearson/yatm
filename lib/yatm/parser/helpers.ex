defmodule Yatm.Parser.Helpers do
  import NimbleParsec

  def whitespace do
    ascii_string([?\s, ?\t, ?\n], min: 1)
    |> ignore()
  end

  def variant do
    choice([identifier(), arbitrary_value()])
    |> string(":")
    |> reduce({Enum, :join, [""]})
  end

  def variants do
    variant()
    |> repeat()
    |> tag(:variants)
    |> optional()
  end

  def number do
    ascii_string([?0..?9], min: 1)
  end

  def fraction do
    ascii_string([?0..?9], min: 1)
    |> string("/")
    |> ascii_string([?0..?9], min: 1)
  end

  def percentage do
    ascii_string([?0..?9], min: 1)
    |> string("%")
  end

  def identifier do
    ascii_string([?a..?z, ?A..?Z, ?0..?9], min: 1)
    |> optional(ascii_string([?a..?z, ?A..?Z, ?0..?9, ?-], min: 1))
  end

  def size_identifier do
    choice([
      string("xs"),
      string("sm"),
      string("base"),
      string("lg"),
      string("xl"),
      string("2xl"),
      string("3xl"),
      string("4xl"),
      string("5xl"),
      string("6xl"),
      string("7xl"),
      string("8xl"),
      string("9xl")
    ])
  end

  def color do
    choice([
      string("inherit"),
      choice([
        string("current"),
        string("transparent"),
        string("black"),
        string("white"),
        choice([
          string("red"),
          string("orange"),
          string("amber"),
          string("yellow"),
          string("lime"),
          string("green"),
          string("emerald"),
          string("teal"),
          string("cyan"),
          string("sky"),
          string("blue"),
          string("indigo"),
          string("violet"),
          string("purple"),
          string("fuchsia"),
          string("pink"),
          string("rose"),
          string("slate"),
          string("gray"),
          string("zinc"),
          string("neutral"),
          string("stone")
        ])
        |> choice([
          string("-100"),
          string("-200"),
          string("-300"),
          string("-400"),
          string("-500"),
          string("-50"),
          string("-600"),
          string("-700"),
          string("-800"),
          string("-900"),
          string("-950")
        ])
      ])
      |> optional(string("/") |> concat(number()))
    ])
  end

  def custom_property(prefix \\ nil)

  def custom_property(nil) do
    string("(--")
    |> ascii_string([?a..?z, ?A..?Z], min: 1)
    |> ascii_string([?-, ?_, ?a..?z, ?A..?Z, ?0..?9], min: 0)
    |> string(")")
  end

  def custom_property(prefix) do
    string("(" <> prefix <> ":--")
    |> ascii_string([?a..?z, ?A..?Z], min: 1)
    |> ascii_string([?-, ?_, ?a..?z, ?A..?Z, ?0..?9], min: 0)
    |> string(")")
  end

  def arbitrary_value do
    string("[")
    |> ascii_string(
      [
        ?a..?z,
        ?A..?Z,
        ?0..?9,
        ?-,
        ?_,
        ?.,
        ?,,
        ?@,
        ?{,
        ?},
        ?(,
        ?),
        ?>,
        ?+,
        ?*,
        ?/,
        ?&,
        ?',
        ?%,
        ?#
      ],
      min: 1
    )
    |> string("]")
  end

  def class(name_or_prefix, combinator \\ nil, keys)

  def class(name, nil, keys) do
    string(name)
    |> choice([whitespace(), eos()])
    |> tag(keys)
  end

  def class(prefix, value, keys) when is_binary(value) do
    string(prefix <> "-")
    |> string(value)
    |> choice([whitespace(), eos()])
    |> tag(keys)
  end

  def class(prefix, combinator, keys) do
    string(prefix <> "-")
    |> concat(combinator)
    |> choice([whitespace(), eos()])
    |> tag(keys)
  end
end
