return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "--",
      function()
        require("conform").format()
        vim.cmd "write"
      end,
      mode = "",
      desc = "LSP Format",
    },
  },
  opts = {
    formatters_by_ft = {
      markdown = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      javascript = { "prettier" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
}
