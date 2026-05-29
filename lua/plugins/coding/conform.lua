return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  keys = {
    {
      "--",
      function()
        require("conform").format()
        if vim.bo.filetype == "typst" then
          local current_line = vim.fn.line(".")
          local total_lines = vim.fn.line("$")
          local function is_table_line(line_num)
            if line_num < 1 or line_num > total_lines then return false end
            local line_text = vim.fn.getline(line_num)
            return line_text:match("^%s*|") ~= nil
          end
          if is_table_line(current_line) then
            local start_line = current_line
            while is_table_line(start_line - 1) do
              start_line = start_line - 1
            end
            local end_line = current_line
            while is_table_line(end_line + 1) do
              end_line = end_line + 1
            end
            local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
            local input_text = table.concat(lines, "\n")
            local cmd = "prettier --parser markdown"
            local formatted_text = vim.fn.system(cmd, input_text)
            if vim.v.shell_error == 0 then
              local output_lines = vim.split(formatted_text, "\n")
              if output_lines[#output_lines] == "" then
                table.remove(output_lines)
              end
              vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, output_lines)
              print(string.format("Formatted table lines %d-%d with Prettier!", start_line, end_line))
            else
              print("Prettier Error: " .. formatted_text)
            end
          end
        end
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
      fortran = { "findent" },
      typst = { "typstyle" }
    },
    formatters = {
      findent = {
        args = { "-i2", "-L72", "-Ia" },
      },
      typstyle = {
        args = { "-l", "120" },
      },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
}
