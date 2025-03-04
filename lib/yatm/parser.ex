defmodule Yatm.Parser do
  import NimbleParsec
  import Yatm.Parser.Helpers

  specs =
    [
      [
        "aspect",
        [fraction(), identifier(), custom_property(), arbitrary_value()],
        [:aspect_ratio]
      ],
      [
        "columns",
        [number(), identifier(), custom_property(), arbitrary_value()],
        [:columns]
      ],
      [
        "break-after",
        ["auto", "avoid", "all", "avoid-page", "page", "left", "right", "column"],
        [:break_after]
      ],
      [
        "break-before",
        ["age", "page", "left", "right", "column"],
        [:break_before]
      ],
      [
        "break-inside",
        ["auto", "avoid", "avoid-page", "avoid-column"],
        [:break_inside]
      ],
      [
        "box-decoration",
        ["clone", "slice"],
        [:box_decoration_break]
      ],
      [
        "box",
        ["border", "content"],
        [:box_sizing]
      ],
      [
        "inline",
        [nil],
        [:display]
      ],
      [
        "block",
        [nil],
        [:display]
      ],
      [
        "inline-block",
        [nil],
        [:display]
      ],
      [
        "flow-root",
        [nil],
        [:display]
      ],
      [
        "flex",
        [nil],
        [:display]
      ],
      [
        "inline-flex",
        [nil],
        [:display]
      ],
      [
        "grid",
        [nil],
        [:display]
      ],
      [
        "inline-grid",
        [nil],
        [:display]
      ],
      [
        "contents",
        [nil],
        [:display]
      ],
      [
        "table",
        [nil],
        [:display]
      ],
      [
        "inline-table",
        [nil],
        [:display]
      ],
      [
        "table-caption",
        [nil],
        [:display]
      ],
      [
        "table-cell",
        [nil],
        [:display]
      ],
      [
        "table-column",
        [nil],
        [:display]
      ],
      [
        "table-column-group",
        [nil],
        [:display]
      ],
      [
        "table-footer-group",
        [nil],
        [:display]
      ],
      [
        "table-header-group",
        [nil],
        [:display]
      ],
      [
        "table-row-group",
        [nil],
        [:display]
      ],
      [
        "table-row",
        [nil],
        [:display]
      ],
      [
        "list-item",
        [nil],
        [:display]
      ],
      [
        "hidden",
        [nil],
        [:display]
      ],
      [
        "sr-only",
        [nil],
        [:display]
      ],
      [
        "not-sr-only",
        [nil],
        [:display]
      ],
      [
        "float",
        ["right", "left", "start", "end", "none"],
        [:float]
      ],
      [
        "clear",
        ["right", "left", "both", "start", "end", "none"],
        [:clear]
      ],
      [
        "isolate",
        [nil],
        [:isolation]
      ],
      [
        "isolation-auto",
        [nil],
        [:isolation]
      ],
      [
        "object",
        ["contain", "cover", "fill", "none", "scale-down"],
        [:object_fit]
      ],
      [
        "object",
        [
          "bottom",
          "center",
          "left",
          "left-bottom",
          "left-top",
          "right",
          "right-bottom",
          "right-top",
          "top",
          custom_property(),
          arbitrary_value()
        ],
        [:object_position]
      ],
      [
        "overflow",
        ["auto", "hidden", "clip", "visible", "scroll"],
        [:overflow]
      ],
      [
        "overflow-x",
        ["auto", "hidden", "clip", "visible", "scroll"],
        [:overflow, :x]
      ],
      [
        "overflow-y",
        ["auto", "hidden", "clip", "visible", "scroll"],
        [:overflow, :y]
      ],
      [
        "overscroll",
        ["auto", "contain", "none"],
        [:overscroll_behavior]
      ],
      [
        "overscroll-x",
        ["auto", "contain", "none"],
        [:overscroll_behavior, :x]
      ],
      [
        "overscroll-y",
        ["auto", "contain", "none"],
        [:overscroll_behavior, :y]
      ],
      [
        "static",
        [nil],
        [:position]
      ],
      [
        "fixed",
        [nil],
        [:position]
      ],
      [
        "absolute",
        [nil],
        [:position]
      ],
      [
        "relative",
        [nil],
        [:position]
      ],
      [
        "sticky",
        [nil],
        [:position]
      ],
      [
        "inset",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset]
      ],
      [
        "-inset",
        [number(), fraction(), "px", "full"],
        [:inset]
      ],
      [
        "inset-x",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :x]
      ],
      [
        "-inset-x",
        [number(), fraction(), "px", "full"],
        [:inset, :x]
      ],
      [
        "inset-y",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :y]
      ],
      [
        "-inset-y",
        [number(), fraction(), "px", "full"],
        [:inset, :y]
      ],
      # TODO: figure out how to establish whether
      # start is left and end is right or the other
      # way around
      [
        "start",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :x, :l]
      ],
      [
        "-start",
        [number(), fraction(), "px", "full"],
        [:inset, :x, :l]
      ],
      [
        "end",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :x, :r]
      ],
      [
        "-end",
        [number(), fraction(), "px", "full"],
        [:inset, :x, :r]
      ],
      [
        "top",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :y, :t]
      ],
      [
        "-top",
        [number(), fraction(), "px", "full"],
        [:inset, :y, :t]
      ],
      [
        "right",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :x, :r]
      ],
      [
        "-right",
        [number(), fraction(), "px", "full"],
        [:inset, :x, :r]
      ],
      [
        "bottom",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :y, :b]
      ],
      [
        "-bottom",
        [number(), fraction(), "px", "full"],
        [:inset, :y, :b]
      ],
      [
        "left",
        [number(), fraction(), "px", "full", "auto", custom_property(), arbitrary_value()],
        [:inset, :x, :l]
      ],
      [
        "-left",
        [number(), fraction(), "px", "full"],
        [:inset, :x, :l]
      ],
      [
        "visible",
        [nil],
        [:visibility]
      ],
      [
        "invisible",
        [nil],
        [:visibility]
      ],
      [
        "collapse",
        [nil],
        [:visibility]
      ],
      [
        "z",
        [number(), "auto", custom_property(), arbitrary_value()],
        [:z_index]
      ],
      [
        "basis",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:flex_basis]
      ],
      [
        "flex",
        ["row", "row-reverse", "col", "col-reverse"],
        [:flex_direction]
      ],
      [
        "flex",
        ["nowrap", "wrap", "wrap-reverse"],
        [:flex_wrap]
      ],
      [
        "flex",
        [
          number(),
          fraction(),
          "auto",
          "initial",
          "none",
          custom_property(),
          arbitrary_value()
        ],
        [:flex]
      ],
      [
        "grow",
        [nil],
        [:flex_grow]
      ],
      [
        "grow",
        [number(), custom_property(), arbitrary_value()],
        [:flex_grow]
      ],
      [
        "shrink",
        [nil],
        [:flex_shrink]
      ],
      [
        "shrink",
        [number(), custom_property(), arbitrary_value()],
        [:flex_shrink]
      ],
      [
        "order",
        [number(), "first", "last", "none", custom_property(), arbitrary_value()],
        [:order]
      ],
      [
        "-order",
        [number()],
        [:order]
      ],
      [
        "grid-cols",
        [number(), "none", "subgrid", custom_property(), arbitrary_value()],
        [:grid_template_columns]
      ],
      [
        "col-span",
        [number(), "full", custom_property(), arbitrary_value()],
        [:grid_column]
      ],
      [
        "col-start",
        [number(), "auto", custom_property(), arbitrary_value()],
        [:grid_column, :start]
      ],
      [
        "-col-start",
        [number()],
        [:grid_column, :start]
      ],
      [
        "col-end",
        [number(), "auto", custom_property(), arbitrary_value()],
        [:grid_column, :end]
      ],
      [
        "-col-end",
        [number()],
        [:grid_column, :end]
      ],
      [
        "col",
        ["auto", custom_property(), arbitrary_value()],
        [:grid_column]
      ],
      [
        "grid-rows",
        [number(), "none", "subgrid", custom_property(), arbitrary_value()],
        [:grid_template_rows]
      ],
      [
        "row-span",
        [number(), "full", custom_property(), arbitrary_value()],
        [:grid_row]
      ],
      [
        "row-start",
        [number(), "auto", custom_property(), arbitrary_value()],
        [:grid_row, :start]
      ],
      [
        "-row-start",
        [number()],
        [:grid_row, :start]
      ],
      [
        "row-end",
        [number(), "auto", custom_property(), arbitrary_value()],
        [:grid_row, :end]
      ],
      [
        "-row-end",
        [number()],
        [:grid_row, :end]
      ],
      [
        "row",
        ["auto", custom_property(), arbitrary_value()],
        [:grid_row]
      ],
      [
        "grid-flow",
        ["row", "col", "dense", "row-dense", "col-dense"],
        [:grid_auto_flow]
      ],
      [
        "auto-col",
        ["auto", "min", "max", "fr", custom_property(), arbitrary_value()],
        [:grid_auto_columns]
      ],
      [
        "auto-rows",
        ["auto", "min", "max", "fr", custom_property(), arbitrary_value()],
        [:grid_auto_rows]
      ],
      [
        "gap",
        [number(), custom_property(), arbitrary_value()],
        [:gap]
      ],
      [
        "gap-x",
        [number(), custom_property(), arbitrary_value()],
        [:gap, :x]
      ],
      [
        "gap-y",
        [number(), custom_property(), arbitrary_value()],
        [:gap, :y]
      ],
      [
        "justify",
        [
          "start",
          "end",
          "center",
          "between",
          "around",
          "evenly",
          "stretch",
          "baseline",
          "normal"
        ],
        [:justify_content]
      ],
      [
        "justify-items",
        ["start", "end", "center", "stretch", "normal"],
        [:justify_items]
      ],
      [
        "justify-self",
        ["auto", "start", "end", "center", "stretch"],
        [:justify_self]
      ],
      [
        "content",
        [
          "normal",
          "center",
          "start",
          "end",
          "between",
          "around",
          "evenly",
          "baseline",
          "stretch"
        ],
        [:align_content]
      ],
      [
        "items",
        ["start", "end", "center", "baseline", "stretch"],
        [:align_items]
      ],
      [
        "self",
        ["auto", "start", "end", "center", "stretch", "baseline"],
        [:align_self]
      ],
      [
        "place-content",
        ["center", "start", "end", "between", "around", "evenly", "baseline", "stretch"],
        [:place_content]
      ],
      [
        "place-items",
        ["start", "end", "center", "baseline", "stretch"],
        [:place_items]
      ],
      [
        "place-self",
        ["auto", "start", "end", "center", "stretch"],
        [:place_self]
      ],
      [
        "p",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding]
      ],
      [
        "px",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :x]
      ],
      [
        "py",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :y]
      ],
      # TODO: figure out how to establish whether
      # start is left and end is right or the other
      # way around
      [
        "ps",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :x, :l]
      ],
      [
        "pe",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :x, :r]
      ],
      [
        "pt",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :y, :t]
      ],
      [
        "pr",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :x, :r]
      ],
      [
        "pb",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :y, :b]
      ],
      [
        "pl",
        [number(), "px", custom_property(), arbitrary_value()],
        [:padding, :x, :l]
      ],
      [
        "m",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin]
      ],
      [
        "-m",
        [number(), "px"],
        [:margin]
      ],
      [
        "mx",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :x]
      ],
      [
        "-mx",
        [number(), "px"],
        [:margin, :x]
      ],
      [
        "my",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :y]
      ],
      [
        "-my",
        [number(), "px"],
        [:margin, :y]
      ],
      # TODO: figure out how to establish whether
      # start is left and end is right or the other
      # way around
      [
        "ms",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :x, :l]
      ],
      [
        "-ms",
        [number(), "px"],
        [:margin, :x, :l]
      ],
      [
        "me",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :x, :r]
      ],
      [
        "-me",
        [number(), "px"],
        [:margin, :x, :r]
      ],
      [
        "mt",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :y, :t]
      ],
      [
        "-mt",
        [number(), "px"],
        [:margin, :y, :t]
      ],
      [
        "mr",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :x, :r]
      ],
      [
        "-mr",
        [number(), "px"],
        [:margin, :x, :r]
      ],
      [
        "mb",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :y, :b]
      ],
      [
        "-mb",
        [number(), "px"],
        [:margin, :y, :b]
      ],
      [
        "ml",
        [number(), "auto", "px", custom_property(), arbitrary_value()],
        [:margin, :x, :l]
      ],
      [
        "-ml",
        [number(), "px"],
        [:margin, :x, :l]
      ],
      [
        "size",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:size]
      ],
      [
        "w",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:size, :width]
      ],
      [
        "min-w",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:min_width]
      ],
      [
        "max-w",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:max_width]
      ],
      # TODO: broken since "container" targets both `width` and `max-width`
      # and the code is structured with the assumption that a given utility
      # targets only one property. Likely solved by tagging with a list of lists
      # of keys, even though only applicable in this utility so far. Will figure
      # out something later. For now, overriding only the `max-width` property.
      [
        "container",
        [nil],
        [:max_width]
      ],
      [
        "h",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:size, :height]
      ],
      [
        "min-h",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:min_height]
      ],
      [
        "max-w",
        [number(), fraction(), identifier(), custom_property(), arbitrary_value()],
        [:max_height]
      ],
      # TODO: can't get away with not parsing the them as there's some conflicts now.
      # For example, `font-display` and `font-extrablack` are not defined in the default
      # theme but could be created by a user. We can't use a generic identifier() and
      # make an assumption of whether the matched class targets `font-family` or `font-weight`.
      # I'll avoid using the generic matcher and will just ignore custom theme values until
      # I work on a solution to this.
      [
        "font",
        ["sans", "serif", "mono", custom_property("family-name"), arbitrary_value()],
        [:font_family]
      ],
      # TODO: pick up custom theme values
      [
        "text",
        [
          size_identifier(),
          custom_property("length"),
          arbitrary_value()
        ],
        [:font_size]
      ],
      [
        "antialiased",
        [nil],
        [:font_smoothing]
      ],
      [
        "subpixel-antialiased",
        [nil],
        [:font_smoothing]
      ],
      [
        "italic",
        [nil],
        [:font_style]
      ],
      [
        "non-italic",
        [nil],
        [:font_style]
      ],
      [
        "font",
        [
          "thin",
          "extralight",
          "light",
          "normal",
          "medium",
          "semibold",
          "bold",
          "extrabold",
          "black",
          custom_property(),
          arbitrary_value()
        ],
        [:font_weight]
      ],
      [
        "font-stretch",
        [
          "ultra-condensed",
          "extra-condensed",
          "condensed",
          "semi-condensed",
          "normal",
          "semi-expanded",
          "expanded",
          "extra-expanded",
          "ultra-expanded",
          percentage(),
          custom_property(),
          arbitrary_value()
        ],
        [:font_stretch]
      ],
      [
        "normal-nums",
        [nil],
        [:font_variant_numeric]
      ],
      [
        "ordinal",
        [nil],
        [:font_variant_numeric, :ordinal]
      ],
      [
        "slashed-zero",
        [nil],
        [:font_variant_numeric, :slashed_zero]
      ],
      [
        "lining-nums",
        [nil],
        [:font_variant_numeric, :lining_nums]
      ],
      [
        "oldstyle-nums",
        [nil],
        [:font_variant_numeric, :oldstyle_nums]
      ],
      [
        "proportional-nums",
        [nil],
        [:font_variant_numeric, :proportional_nums]
      ],
      [
        "tabular-nums",
        [nil],
        [:font_variant_numeric, :tabular_nums]
      ],
      [
        "diagonal-fractions",
        [nil],
        [:font_variant_numeric, :diagonal_fractions]
      ],
      [
        "stacked-fractions",
        [nil],
        [:font_variant_numeric, :stacked_fractions]
      ],
      # TODO: custom theme could define negative values as in `-tracking-1`
      [
        "tracking",
        [identifier(), custom_property(), arbitrary_value()],
        [:letter_spacing]
      ],
      # TODO: figure out how to handle this type of utility again targeting
      # several properties like `overflow` and `display`. Ignoring for now.
      [
        "line-clamp",
        [number(), "none", custom_property(), arbitrary_value()],
        [:line_clamp]
      ],
      # TODO: another multiple-property utility, damn! This one's pretty key
      # I think. Should prioritise. Will only target `line-height` override
      # for now.
      [
        "text",
        [
          size_identifier() |> string("/") |> concat(number()),
          size_identifier() |> string("/") |> concat(custom_property()),
          size_identifier() |> string("/") |> concat(arbitrary_value())
        ],
        [:line_height]
      ],
      [
        "leading",
        ["none", number(), custom_property(), arbitrary_value()],
        [:line_height]
      ],
      [
        "list-image",
        [arbitrary_value(), custom_property(), "none"],
        [:list_style_image]
      ],
      [
        "list",
        ["inside", "outside"],
        [:list_style_position]
      ],
      # TODO: does `list-style-type` conflict with `list-style-image`?
      [
        "list",
        ["disc", "decimal", "none", custom_property(), arbitrary_value()],
        [:list_style_type]
      ],
      [
        "text",
        ["left", "center", "right", "justify", "start", "end"],
        [:text_align]
      ],
      # TODO: my abstractions are breaking down! Will have to rethink
      # things. Parsing the user's theme seems more and more of a
      # requirement.
      [
        "text",
        [
          color(),
          custom_property(),
          # TODO: for example, this pattern will never provide a hit because
          # a valid `text-[...]` will be interpreted as `font-size`. Unsure
          # how to deal with this other than parsing the arbitrary CSS
          # content and establishing the result type of the expression. Will
          # parse incorrectly for now.
          arbitrary_value()
        ],
        [:color]
      ],
      [
        "underline",
        [nil],
        [:text_decoration_line]
      ],
      [
        "overline",
        [nil],
        [:text_decoration_line]
      ],
      [
        "line-through",
        [nil],
        [:text_decoration_line]
      ],
      [
        "no-underline",
        [nil],
        [:text_decoration_line]
      ],
      [
        "decoration",
        [color(), custom_property(), arbitrary_value()],
        [:text_decoration_color]
      ]
      # TODO: continue with `text-decoration-style`
    ]

  classes =
    for [label, values, keys] <- specs, value <- values do
      class(label, value, keys)
    end

  defparsec(
    :parse,
    optional(whitespace())
    |> repeat(
      variants()
      |> concat(choice(classes))
    )
  )
end
