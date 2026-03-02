return {
  {
    "lervag/vimtex",
    ft = "tex",
    dependencies = {
      {
        "iurimateus/luasnip-latex-snippets.nvim",
        dependencies = { "L3MON4D3/LuaSnip" },
        config = function()
          require 'luasnip-latex-snippets'.setup()
          require("luasnip").config.setup { enable_autosnippets = true }
        end
      }
    },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_syntax_enabled = 1
      vim.opt.conceallevel = 1
      vim.g.vimtex_quickfix_mode = 0
      vim.g.tex_conceal = 'abdmg'
      vim.g.tex_flavor = 'latex'
      vim.cmd([[
        inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
        nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
        ]])
    end,
  },
  { "iffse/qalculate.vim", ft = "qalculate" },
  -- { "ixru/nvim-markdown",  ft = "markdown" },
  { "mipmip/vim-scimark",  ft = "markdown" },
  {
    "vimwiki/vimwiki",
    lazy = false,
    init = function()
      vim.g.vimwiki_list = {
        {
          path = "~/Notes",
          syntax = "markdown",
          ext = ".md",
        },
      }
      vim.g.vimwiki_markdown_link_ext = 1
    end,
  },
  {
    "tbabej/taskwiki",
    event = "VeryLazy",
    dependencies = {
      "powerman/vim-plugin-AnsiEsc"
    },
    init = function()
      vim.g.taskwiki_markup_syntax = "markdown"
      vim.g.markdown_folding = 1
    end,
  }
}
