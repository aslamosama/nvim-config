return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = { "bash", "cpp", "diff", "html", "css", "make", "json", "luadoc", "regex", "yaml", "python" },
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "<C-i>",
      --     node_incremental = "<C-i>",
      --     scope_incremental = false,
      --     node_decremental = "<bs>",
      --   },
      -- },
    },
  },
}
