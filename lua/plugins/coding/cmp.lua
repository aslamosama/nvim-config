return {
  {
    "saghen/blink.compat",
    -- use a release tag to download pre-built binaries
    version = '*',
    lazy = true,
    opts = {}
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-calc",
      "micangl/cmp-vimtex",
      "kdheepak/cmp-latex-symbols",
      "becknik/blink-cmp-luasnip-choice",
      "jc-doyle/cmp-pandoc-references",
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        config = function()
          local luasnip = require("luasnip")
          luasnip.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
          })
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = "~/.config/nvim/snippets",
          })
          require("luasnip.loaders.from_lua").lazy_load({
            paths = "~/.config/nvim/snippets",
          })
        end,
      },
    },
    opts = {
      snippets = { preset = "luasnip" },
      appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "normal" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { border = 'single', draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = false },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true },
      sources = {
        providers = {
          choice = { name = 'LuaSnip Choice Nodes', module = 'blink-cmp-luasnip-choice', opts = {} },
          calc = { name = "calc", module = 'blink.compat.source', opts = {} },
          vimtex = { name = "vimtex", module = 'blink.compat.source', opts = {} },
          pandoc_references = { name = "pandoc_references", module = 'blink.compat.source', opts = {} },
          latex_symbols = { name = "latex_symbols", module = 'blink.compat.source', opts = { strategy = 0 } },
        },
        default = { "choice", "lsp", "path", "snippets", "buffer", "latex_symbols", "calc", "vimtex", "pandoc_references" },
      },
      cmdline = { enabled = false },
      keymap = { preset = "enter", ["<C-y>"] = { "select_and_accept" } },
    },
  }
}
