return {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    servers = {
      lua_ls = {},   -- pacman: lua-language-server
      clangd = {},   -- pacman: clang
      bashls = {},   -- pacman: bash-language-server
      ruff = {},     -- pacman: ruff
      pyright = {},  -- pacman: pyright
      tinymist = {}, -- pacman: tinymist
      jsonls = {},   -- AUR: vscode-langservers-extracted
      cssls = {},    -- AUR: vscode-langservers-extracted
      eslint = {},   -- AUR: vscode-langservers-extracted
      html = {},     -- AUR: vscode-langservers-extracted
      iwes = {       -- AUR: iwe-bin
        name = 'iwes',
        cmd = { 'iwes' },
        filetypes = { "markdown" },
        root_dir = ".iwe" or vim.fn.getcwd(),
        flags = {
          debounce_text_changes = 500,
          exit_timeout = false
        }
      }
    }
  },
  config = function(_, opts)
    for server, config in pairs(opts.servers) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end
}
