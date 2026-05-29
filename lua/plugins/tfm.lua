return {
  "rolv-apneseth/tfm.nvim",
  keys = {
    { "<leader><space>", function() require("tfm").open() end,                                      desc = "file_manager" },
    { "<leader>fh",      function() require("tfm").open(nil, require("tfm").OPEN_MODE.split) end,   desc = "file_manager hsplit" },
    { "<leader>fv",      function() require("tfm").open(nil, require("tfm").OPEN_MODE.vsplit) end,  desc = "file_manager vsplit" },
    { "<leader>ft",      function() require("tfm").open(nil, require("tfm").OPEN_MODE.tabedit) end, desc = "file_manager tab" },
  },
  opts = {
    file_manager = "yazi",
    replace_netrw = true,
    ui = {
      border = "single",
      height = 0.5,
      width = 0.6,
      x = 0,
      y = 0,
    },
  },
}
