return {
  {
    "mfussenegger/nvim-lint",
    enabled = false,
    ft = { "fortran" },
    opts = {},
    config = function()
      require('lint').linters_by_ft = {
        fortran = { 'fortitude' }, -- AUR: fortitude-bin
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  }
}
