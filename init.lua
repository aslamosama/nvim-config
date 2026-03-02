vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("manager")
require("options")
require("keymaps")
require("autocmds")

local function clean_filename(name)
  -- 1. Separate filename from extension
  -- This handles the "keep only the last full stop" rule
  local stem, ext = name:match("^(.*)%.([^.]+)$")

  if not stem then
    stem = name
    ext = ""
  else
    ext = "." .. ext
  end

  -- 2. Lowercase everything (stem only)
  stem = stem:lower()

  -- 3. Replace spaces with underscores
  stem = stem:gsub("%s+", "_")

  -- 4. Keep only alphanumeric (a-z, 0-9) and underscores
  -- [^%w_] matches any character that is NOT a letter, digit, or underscore
  stem = stem:gsub("[^%w_]", "")

  -- 5. Collapse multiple underscores into one
  stem = stem:gsub("__+", "_")

  -- 6. Trim leading/trailing underscores
  stem = stem:gsub("^_+", ""):gsub("_+$", "")

  return stem .. ext
end

vim.api.nvim_create_user_command('CleanFilenames', function(opts)
  local start_line = opts.line1
  local end_line = opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  local cleaned_lines = {}
  for _, line in ipairs(lines) do
    table.insert(cleaned_lines, clean_filename(line))
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, cleaned_lines)
end, { range = true })
