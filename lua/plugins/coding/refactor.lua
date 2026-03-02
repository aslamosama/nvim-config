return {
  {
    "ThePrimeagen/refactoring.nvim",
    ft = { "c", "cpp", "javascript", "python", "lua" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function()
      vim.keymap.set("x", "-re", ":Refactor extract ", { desc = "Extract" })
      vim.keymap.set("x", "-rf", ":Refactor extract_to_file ", { desc = "Extract to File" })
      vim.keymap.set("x", "-rv", ":Refactor extract_var ", { desc = "Extract Var" })
      vim.keymap.set({ "n", "x" }, "-ri", ":Refactor inline_var", { desc = "Extract Inline Var" })
      vim.keymap.set("n", "-rI", ":Refactor inline_func", { desc = "Extract Func" })
      vim.keymap.set("n", "-rb", ":Refactor extract_block", { desc = "Extract Block" })
      vim.keymap.set("n", "-rbf", ":Refactor extract_block_to_file", { desc = "Extract Block to FIle" })
    end
  }
}
