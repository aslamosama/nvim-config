local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local function in_math()
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == "math" then
      return true
    end
    node = node:parent()
  end
  return false
end


local snippets = {

  s(
    { trig = "frac", name = "Math: Fraction" },
    fmta([[(<>) / (<>)<>]], { i(1, "num"), i(2, "den"), i(0) }),
    { condition = in_math }
  ),


  s(
    { trig = "sub", name = "Math: Subscript Block" },
    fmta([[<>_(<>)<>]], { i(1, "x"), i(2, "sub"), i(0) }),
    { condition = in_math }
  ),


  s(
    { trig = "power", name = "Math: Exponent Block" },
    fmta([[<>^(<>)<>]], { i(1, "x"), i(2, "exp"), i(0) }),
    { condition = in_math }
  ),


  s(
    { trig = "sqrt", name = "Math: Square Root" },
    fmta([[sqrt(<>)<>]], { i(1), i(0) }),
    { condition = in_math }
  ),

  s(
    { trig = "derivative", name = "Math: Parenthesized Derivative Fraction" },
    fmta([[(dif <>) / (dif <>)<>]], { i(1, "f"), i(2, "x"), i(0) }),
    { condition = in_math }
  ),


  s(
    { trig = "derivative_op", name = "Math: Operator Derivative Style" },
    fmta([[dif / (dif <>) <>]], { i(1, "x"), i(0) }),
    { condition = in_math }
  ),


  s(
    { trig = "pderivative", name = "Math: Parenthesized Partial Derivative" },
    fmta([[(partial <>) / (partial <>)<>]], { i(1, "psi"), i(2, "x"), i(0) }),
    { condition = in_math }
  ),


  s(
    { trig = "pderivative_op", name = "Math: Operator Partial Style" },
    fmta([[partial / (partial <>) <>]], { i(1, "x"), i(0) }),
    { condition = in_math }
  ),

  s(
    { trig = "sum", name = "Math: Summation" },
    fmta([[sum_(<> = <>)^(<>) <>]], { i(1, "i"), i(2, "1"), i(3, "n"), i(0) }),
    { condition = in_math }
  ),

  s(
    { trig = "int", name = "Math: Definite Integral" },
    fmta([[integral_(<>)^(<>) <> dif <>]], { i(1, "a"), i(2, "b"), i(3, "f(x)"), i(4, "x") }),
    { condition = in_math }
  ),

  s(
    { trig = "lap", name = "Math: Laplace Transform" },
    fmta([[cal(L) lr({ <> })<>]], { i(1), i(0) }),
    { condition = in_math }
  ),

  s(
    { trig = "inv", name = "Math: Inverse Power", snippetType = "autosnippet" },
    fmta([[^(-1)<>]], { i(0) }),
    { condition = in_math }
  ),


  s(
    { trig = "sq", name = "Math: Squared", snippetType = "autosnippet" },
    fmta([[^2<>]], { i(0) }),
    { condition = in_math }
  ),
  s(
    { trig = "cb", name = "Math: Cubed", snippetType = "autosnippet" },
    fmta([[^3<>]], { i(0) }),
    { condition = in_math }
  ),

  s(
    { trig = "..", name = "Math: Dot Product", snippetType = "autosnippet" },
    fmta([[ dot <>]], { i(0) }),
    { condition = in_math }
  ),

  s(
    { trig = "xx", name = "Math: Cross Product", snippetType = "autosnippet" },
    fmta([[ times <>]], { i(0) }),
    { condition = in_math }
  ),

  s(
    { trig = "imath", name = "Inline Math", snippetType = "autosnippet" },
    fmta([[$<>$<>]], { i(1), i(0) })
  ),


  s(
    { trig = "dmath", name = "Display Math Block", snippetType = "autosnippet" },
    fmta(
      [[
      $
      <>
      $
      <>
      ]],
      { i(1), i(0) }
    )
  ),

  s(
    { trig = "equation", name = "Numbered Equation Block" },
    fmta(
      [[
      $
      <>
      $
      <<eqn-<>>>
      <>
      ]],
      {
        i(1, "E = m c^2"),
        i(2, "label-name"),
        i(0),
      }
    )
  ),

  s(
    { trig = "lorem", name = "Lorem Ipsum Placeholder" },
    fmta(
      [[#lorem(<>)<>]],
      {
        i(1, "30"),
        i(0),
      }
    )
  ),

  s(
    { trig = "ulist", name = "Unordered List" },
    fmta(
      [[
      - <>
      - <>
      <>
      ]],
      {
        i(1, "First item"),
        i(2, "Second item"),
        i(0),
      }
    )
  ),
  s(
    { trig = "olist", name = "Ordered List" },
    fmta(
      [[
      + <>
      + <>
      <>
      ]],
      {
        i(1, "First step"),
        i(2, "Second step"),
        i(0),
      }
    )
  ),
  s(
    { trig = "lnk", name = "Insert Link" },
    fmta(
      [[#link("<>")[_<>_]<>]],
      {
        c(1, {
          i(1, 'https://google.com'),
          i(1, 'mailto:sam@example.com'),
        }),
        i(2, "Display Text"),
        i(0),
      }
    )
  ),

  s(
    { trig = "footnote", name = "Insert Footnote" },
    fmta(
      [[#footnote[<>]<>]],
      {
        i(1, "Footnote text"),
        i(0),
      }
    )
  ),

  s(
    { trig = "ref", name = "Insert Reference/Citation", snippetType = "autosnippet" },
    fmta(
      [[@<>]],
      {
        i(1, "label"),
      }
    )
  ),

  s(
    { trig = "fig", name = "Insert Figure with Auto-Python Script" },
    fmta(
      [[
      #figure(
        image("./figures/<>", width: <>%),
        caption: [<>],
      )<<<>>>

      <>
      ]],
      {
        i(1, "plot.pdf", {
          node_callbacks = {
            [require("luasnip.util.events").leave] = function(node)

              local filename = table.concat(node:get_text(), "")
              if filename == "" or filename == "plot.png" then return end


              local figures_dir = vim.fn.getcwd() .. "/figures"
              local img_path = figures_dir .. "/" .. filename

              local base_name = filename:match("(.+)%.%w+$") or filename
              local py_script_path = figures_dir .. "/" .. base_name .. ".py"

              local file_exists = vim.uv.fs_stat(img_path) ~= nil
              if not file_exists then

                vim.fn.mkdir(figures_dir, "p")

                local py_content = {
                  "import matplotlib as mpl",
                  "import matplotlib.pyplot as plt",
                  "import numpy as np",
                  "",
                  "mpl.use('pgf')",
                  "plt.rcParams.update({",
                  "    'pgf.texsystem': 'xelatex',",
                  "    'text.usetex': True,",
                  "    'pgf.rcfonts': False,",
                  "    'pgf.preamble': r'''",
                  "        \\usepackage{amsmath}",
                  "        \\usepackage{amssymb}",
                  "        \\usepackage{mathtools}",
                  "        \\usepackage{unicode-math}",
                  "        \\usepackage{bm}",
                  "",
                  "        \\setmainfont{IBM Plex Sans}",
                  "        \\setmathfont{STIX Two Math}",
                  "    ''',",
                  "})",
                  "",
                  "# Data generation",
                  "x = np.linspace(0, 10, 100)",
                  "y = np.sin(x)",
                  "",
                  "# Plot configuration",
                  "plt.figure(figsize=(6, 4))",
                  "plt.plot(x, y, label='Sine Wave')",
                  "plt.title('" .. base_name .. "')",
                  "plt.xlabel('X axis')",
                  "plt.ylabel('Y axis')",
                  "plt.legend()",
                  "plt.grid(True)",
                  "",
                  "# Save target",
                  "plt.savefig('" .. filename .. "', bbox_inches='tight', dpi=300)",
                }

                local f = io.open(py_script_path, "w")
                if f then
                  f:write(table.concat(py_content, "\n"))
                  f:close()
                  vim.notify("Created script: ./figures/" .. base_name .. ".py", vim.log.levels.INFO)
                else
                  vim.notify("Failed to write python script framework", vim.log.levels.ERROR)
                end
              end
            end
          }
        }),
        i(2, "100"),
        i(3, "Caption text"),
        i(4, "label-name"),
        i(0),
      }
    )
  ),

  s({ trig = "1h", name = "Heading Level 1" }, fmta("= <><>", { i(1, "Heading 1"), i(0) })),
  s({ trig = "2h", name = "Heading Level 2" }, fmta("== <><>", { i(1, "Heading 2"), i(0) })),
  s({ trig = "3h", name = "Heading Level 3" }, fmta("=== <><>", { i(1, "Heading 3"), i(0) })),
  s({ trig = "4h", name = "Heading Level 4" }, fmta("==== <><>", { i(1, "Heading 4"), i(0) })),
  s({ trig = "5h", name = "Heading Level 5" }, fmta("===== <><>", { i(1, "Heading 5"), i(0) })),
  s({ trig = "6h", name = "Heading Level 6" }, fmta("====== <><>", { i(1, "Heading 6"), i(0) })),

  s(
    { trig = "bold", name = "Bold Text", snippetType = "autosnippet" },
    fmta("*<>*<>", { i(1), i(0) })
  ),

  s(
    { trig = "italic", name = "Italic Text", snippetType = "autosnippet" },
    fmta("_<>_<>", { i(1), i(0) })
  ),

  s(
    { trig = "bolditalic", name = "Bold Italic Text", snippetType = "autosnippet" },
    fmta("*_<>_*<>", { i(1), i(0) })
  ),

  s(
    { trig = "underline", name = "Underline Text" },
    fmta("#underline[<>]<>", { i(1), i(0) })
  ),

  s(
    { trig = "strike", name = "Strike-through Text" },
    fmta("#strike[<>]<>", { i(1), i(0) })
  ),

  s(
    { trig = "super", name = "Superscript Text" },
    fmta("#super[<>]<>", { i(1), i(0) })
  ),

  s(
    { trig = "sub", name = "Subscript Text" },
    fmta("#sub[<>]<>", { i(1), i(0) })
  ),

  s(
    { trig = "cmd", name = "Env: Command Line Output Block" },
    fmta(
      [[
      #commandline[<>][
        ```
        <>
        ```
      ]
      <>
      ]],
      {
        i(1, "Output"),
        i(2, "Command logs"),
        i(0),
      }
    )
  ),

  s(
    { trig = "codeblock", name = "Env: Zebraw Code Block" },
    fmta(
      [[
      #zebraw(
        indentation: 4,
        numbering: true,
        lang: true,
        numbering-separator: false,
        highlight-lines: none,
        header: [*<>*],
        footer: none,
        ```<>
        <>
        ```,
      )
      <>
      ]],
      {
        i(1, "Header Title"),
        i(2, "python"),
        i(3, "print('hello world')"),
        i(0),
      }
    )
  ),

  s(
    { trig = "algo", name = "Env: Algorithm Blocks" },
    fmta(
      [[
      #algorithm[<>][
        #pseudocode-list[
          + *Input:* <>
        ]
      ]
      <>
      ]],
      {
        i(1, "Algorithm Name"),
        i(2, "$$"),
        i(0),
      }
    )
  ),

  s(
    { trig = "hint", name = "Env: Hint" },
    fmta([[
    #hint[
      <>
    ]
    <>
    ]], { i(1, "Body content..."), i(0) })
  ),

  s(
    { trig = "intu", name = "Env: Intuition" },
    fmta([[
    #intuition[
      <>
    ]
    <>
    ]], { i(1, "Body content..."), i(0) })
  ),

  s(
    { trig = "rem", name = "Env: Remark" },
    fmta([[
    #remark[
      <>
    ]
    <>
    ]], { i(1, "Body content..."), i(0) })
  ),

  s(
    { trig = "info", name = "Env: Information" },
    fmta([[
    #information[
      <>
    ]
    <>
    ]], { i(1, "Body content..."), i(0) })
  ),

  s(
    { trig = "def", name = "Env: Definition" },
    fmta([[
    #definition[<>][
      <>
    ]
    <>
    ]], { i(1, "Definition"), i(2, "Definition body..."), i(0) })
  ),

  s(
    { trig = "prop", name = "Env: Property" },
    fmta([[
    #property[<>][
      <>
    ]
    <>
    ]], { i(1, "Property"), i(2, "Property body..."), i(0) })
  ),

  s(
    { trig = "thm", name = "Env: Theorem" },
    fmta([[
    #theorem[<>][
      <>
    ]
    <>
    ]], { i(1, "Theorem"), i(2, "Theorem body..."), i(0) })
  ),

  s(
    { trig = "cor", name = "Env: Corollary" },
    fmta([[
    #corollary[<>][
      <>
    ]
    <>
    ]], { i(1, "Corollary"), i(2, "Corollary body..."), i(0) })
  ),

  s(
    { trig = "prob", name = "Env: Problem" },
    fmta([[
    #problem[<>][
      <>
    ]
    <>
    ]], { i(1, "Problem"), i(2, "Problem body..."), i(0) })
  ),

  s(
    { trig = "ex", name = "Env: Example" },
    fmta([[
    #example[<>][
      <>
    ]
    <>
    ]], { i(1, "Example"), i(2, "Example body..."), i(0) })
  ),

  s(
    { trig = "sol", name = "Env: Solution" },
    fmta([[
    #solution[<>][
      <>
    ]
    <>
    ]], { i(1, "Solution"), i(2, "Solution body..."), i(0) })
  ),


  s(
    { trig = "abs", name = "Abstract Placement Block" },
    fmta(
      [[
      #abstract[
        <>
      ]
      <>
      ]],
      {
        i(1, "Abstract text goes here..."),
        i(0),
      }
    )
  ),

  s(
    { trig = "mdt", name = "Insert Markdown Table" },
    fmta(
      [[
      // @typstyle off
      #mdtable(
        header: top+left,
        zebra: true,
        caption: [<>],
        label: <<tbl-<>>>
      )[
      | <> | <> |
      | -- | -- |
      | <> | <> |
      ]
      <>
      ]],
      { i(1, "Caption"), i(2, "label"), i(3, "H1"), i(4, "H2"), i(5, "C1"), i(6, "C2"), i(0) }
    )
  ),
}

local function generate_md_table_snippet(cols, rows)
  local format_string = [[
// @typstyle off
#mdtable(
  header: top+left,
  zebra: true,
  caption: [<>],
  label: <<tbl-<>>>
)[
]]

  local current_idx = 3
  local nodes = {
    i(1, "Caption Text"),
    i(2, string.format("table-%dx%d", cols, rows))
  }

  local header_line = "|"
  for c = 1, cols do
    header_line = header_line .. " <> |"
    table.insert(nodes, i(current_idx, "H" .. c))
    current_idx = current_idx + 1
  end
  format_string = format_string .. header_line .. "\n"

  local separator_line = "|"
  for _ = 1, cols do
    separator_line = separator_line .. " --- |"
  end
  format_string = format_string .. separator_line .. "\n"

  for r = 1, rows do
    local row_line = "|"
    for c = 1, cols do
      row_line = row_line .. " <> |"
      table.insert(nodes, i(current_idx, string.format("R%dC%d", r, c)))
      current_idx = current_idx + 1
    end
    format_string = format_string .. row_line .. "\n"
  end

  format_string = format_string .. "]\n<>"
  table.insert(nodes, i(0))

  return s(
    {
      trig = string.format("mdt%dx%d", cols, rows),
      name = string.format("Markdown Table %dx%d", cols, rows)
    },
    fmta(format_string, nodes)
  )
end

for c = 2, 5 do
  for r = 2, 5 do
    table.insert(snippets, generate_md_table_snippet(c, r))
  end
end
return snippets
