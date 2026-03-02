vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_left = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_top = 5
vim.opt.autochdir = true
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.autowrite = false
vim.opt.backspace = "indent,eol,start"
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.cmdheight = 1
-- vim.opt.colorcolumn = "80"
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.concealcursor = ""
vim.opt.cursorline = true
vim.opt.diffopt:append("linematch:60")
vim.opt.encoding = "utf-8"
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.foldcolumn = "0"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.formatoptions = "qjl1"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.iskeyword:append("-")
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = "tab:> ,extends:…,precedes:…,nbsp:␣"
vim.opt.maxmempattern = 20000
vim.opt.modifiable = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.redrawtime = 10000
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 10
vim.opt.selection = "inclusive"
vim.opt.shiftwidth = 2
vim.opt.shortmess:append("Wc")
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.smoothscroll = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.synmaxcol = 300
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 0
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.virtualedit = "block"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.winblend = 0
vim.opt.wrap = true
vim.opt.writebackup = false

vim.filetype.add({ extension = { qalc = "qalculate" } })

vim.cmd("hi Comment gui=italic cterm=italic")
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "Comment" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "Comment" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "Comment" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "Comment" })
vim.diagnostic.config({
  underline = false,
  virtual_text = { current_line = false, severity = { min = "INFO", max = "ERROR" } },
  -- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.WARN] = "",
    },
  },
})
