---@diagnostic disable: undefined-global
return {
  "echasnovski/mini.nvim",
  config = function()
    local standard_plugins = { "ai", "icons", "move", "git", "comment", "bracketed", "sessions", "misc" }
    for _, plugin in ipairs(standard_plugins) do
      require("mini." .. plugin).setup()
    end

    MiniMisc.setup_termbg_sync()
    MiniMisc.setup_restore_cursor()

    require("mini.diff").setup({ view = { style = 'number' } })

    local diag_signs = { ERROR = ' ', WARN = ' ', INFO = ' ', HINT = '󰌵 ' }
    require('mini.statusline').setup({
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75, signs = diag_signs })
          local filename      = vim.fn.expand('%:t')
          local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
          local git           = MiniStatusline.section_git({ trunc_width = 40 })
          local location      = string.format('%2d:%-2d', vim.fn.line('.'), vim.fn.col('.'))
          local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })
          return MiniStatusline.combine_groups({
            { hl = mode_hl,                 strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { diagnostics } },
            '%<',
            '%=',
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=',
            { hl = 'MiniStatuslineDevinfo',  strings = { lsp, git } },
            { hl = mode_hl,                  strings = { search, location } },
          })
        end,
        inactive = function()
          local filename = vim.fn.expand('%:t')
          return MiniStatusline.combine_groups({
            { hl = 'MiniStatuslineFilename', strings = { filename } },
          })
        end,
      },
      use_icons = true,
      set_vim_settings = true,
    })

    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        local bg_color = vim.fn.synIDattr(vim.fn.hlID('Normal'), 'bg')
        local fg_color = vim.fn.synIDattr(vim.fn.hlID('Comment'), 'fg')

        local hl_groups = { 'MiniStatuslineModeNormal', 'MiniStatuslineModeInsert', 'MiniStatuslineModeVisual',
          'MiniStatuslineModeReplace', 'MiniStatuslineModeCommand', 'MiniStatuslineModeOther', 'MiniStatuslineDevinfo',
          'MiniStatuslineFilename', 'MiniStatuslineFileinfo', 'MiniStatuslineInactive', }
        for _, group in ipairs(hl_groups) do
          vim.api.nvim_set_hl(0, group, { bg = bg_color, fg = fg_color })
        end
      end,
    })
    vim.cmd('doautocmd ColorScheme')

    require("mini.surround").setup({
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
        update_n_lines = "gzn",
      },
    })

    require("mini.pairs").setup({
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    })

    require("mini.hipatterns").setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      },
    })
  end,
}
