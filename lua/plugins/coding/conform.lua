return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  keys = {
    {
      "--",
      function()
        require("conform").format()
        -- local fname = vim.api.nvim_buf_get_name(0)
        -- if fname:match("%.for$") then
        --   vim.cmd([[%s/^/      /e]])
        -- end
        vim.cmd("write")
      end,
      mode = "",
      desc = "LSP Format",
    },
  },
  opts = {
    formatters_by_ft = {
      markdown = { "prettier" },
      vimwiki = { "prettier" },
      sh = { "shfmt" },      -- pacman: shfmt
      html = { "prettier" }, -- pacman: prettier
      css = { "prettier" },
      javascript = { "prettier" },
      json = { "prettier" },
      fortran = { "findent" }
    },
    formatters = {
      findent = {
        args = { "-i2", "-L72", "-Ia" },
      },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
}
