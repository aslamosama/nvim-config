vim.api.nvim_create_user_command('TypstCompileFigures', function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local blocks = {}
  local state = "searching"
  local current_block = {}

  -- Step 1: Scan the buffer for matching code blocks
  for i, line in ipairs(lines) do
    -- Remove any trailing carriage returns (Windows compatibility)
    line = line:gsub("\r$", "")

    if state == "searching" then
      local caption = line:match("^//%s*[Cc]aption:%s*(.-)%s*$")
      if caption then
        current_block = { start_idx = i, caption = caption }
        state = "got_caption"
      end
    elseif state == "got_caption" then
      local filename = line:match("^//%s*[Ff]ilename:%s*(.-)%s*$")
      if filename then
        current_block.filename = filename
        state = "got_filename"
      else
        -- If it's not a filename, check if it's another caption to reset cleanly
        local caption = line:match("^//%s*[Cc]aption:%s*(.-)%s*$")
        if caption then
          current_block = { start_idx = i, caption = caption }
          state = "got_caption"
        else
          state = "searching"
        end
      end
    elseif state == "got_filename" then
      if line:match("^```python") then
        current_block.code = {}
        state = "in_code"
      else
        state = "searching"
      end
    elseif state == "in_code" then
      if line:match("^```%s*$") then
        current_block.end_idx = i
        table.insert(blocks, current_block)
        state = "searching"
      else
        table.insert(current_block.code, line)
      end
    end
  end

  if #blocks == 0 then
    vim.notify("No valid Python figure blocks found.", vim.log.levels.INFO)
    return
  end

  -- Ensure the target figures directory exists
  vim.fn.mkdir("figures", "p")

  -- Determine the correct python command executable available on your system
  local python_cmd = vim.fn.executable("python3") == 1 and "python3" or "python"

  -- Step 2: Process blocks from bottom to top (prevents line index shifting)
  for i = #blocks, 1, -1 do
    local block = blocks[i]
    local py_filename = "figures/" .. block.filename .. ".py"
    local pdf_path = "figures/" .. block.filename .. ".pdf"

    -- Smart adjustment: update or append plt.savefig to match the expected location
    local updated_code = {}
    local has_savefig = false
    for _, code_line in ipairs(block.code) do
      if code_line:match("plt%.savefig") then
        code_line = string.format('plt.savefig("%s")', pdf_path)
        has_savefig = true
      end
      table.insert(updated_code, code_line)
    end
    if not has_savefig then
      table.insert(updated_code, string.format('plt.savefig("%s")', pdf_path))
    end

    -- Write the python script out to the file
    local f = io.open(py_filename, "w")
    if f then
      f:write(table.concat(updated_code, "\n"))
      f:close()

      -- Execute the script synchronously using vim.fn.system
      local output = vim.fn.system(string.format("%s %s", python_cmd, vim.fn.shellescape(py_filename)))

      if vim.v.shell_error ~= 0 then
        vim.notify("Error executing " .. py_filename .. ":\n" .. output, vim.log.levels.ERROR)
      else
        -- Generate the replacement Typst structural block
        local replacement = {
          "#figure(",
          string.format('  image("./%s", width: 100%%),', pdf_path),
          string.format('  caption: [%s],', block.caption),
          string.format(")<fig-%s>", block.filename)
        }

        -- Replace the old code block lines in the current buffer
        -- nvim_buf_set_lines uses 0-indexed ranges where end index is exclusive
        vim.api.nvim_buf_set_lines(buf, block.start_idx - 1, block.end_idx, false, replacement)
      end
    else
      vim.notify("Failed to write to file path: " .. py_filename, vim.log.levels.ERROR)
    end
  end

  vim.notify("Successfully processed " .. #blocks .. " figure block(s).", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command('Figcompile', function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local blocks = {}
  local state = "searching"
  local current_block = {}

  -- Step 1: Scan the buffer for matching python or tikz/latex blocks
  for i, line in ipairs(lines) do
    line = line:gsub("\r$", "") -- Windows compatibility

    if state == "searching" then
      local caption = line:match("^//%s*[Cc]aption:%s*(.-)%s*$")
      if caption then
        current_block = { start_idx = i, caption = caption }
        state = "got_caption"
      end
    elseif state == "got_caption" then
      local filename = line:match("^//%s*[Ff]ilename:%s*(.-)%s*$")
      if filename then
        current_block.filename = filename
        state = "got_filename"
      else
        local caption = line:match("^//%s*[Cc]aption:%s*(.-)%s*$")
        if caption then
          current_block = { start_idx = i, caption = caption }
          state = "got_caption"
        else
          state = "searching"
        end
      end
    elseif state == "got_filename" then
      local lang = line:match("^```(%w+)%s*$")
      if lang == "python" or lang == "tikz" or lang == "latex" then
        current_block.type = (lang == "python") and "python" or "latex"
        current_block.code = {}
        state = "in_code"
      else
        state = "searching"
      end
    elseif state == "in_code" then
      if line:match("^```%s*$") then
        current_block.end_idx = i
        table.insert(blocks, current_block)
        state = "searching"
      else
        table.insert(current_block.code, line)
      end
    end
  end

  if #blocks == 0 then
    vim.notify("No valid figure blocks found.", vim.log.levels.INFO)
    return
  end

  -- Ensure figures directory exists
  vim.fn.mkdir("figures", "p")
  local python_cmd = vim.fn.executable("python3") == 1 and "python3" or "python"

  -- Step 2: Process blocks from bottom to top
  for i = #blocks, 1, -1 do
    local block = blocks[i]
    local pdf_path = "figures/" .. block.filename .. ".pdf"
    local success = false
    local err_msg = ""

    if block.type == "python" then
      -- --- PYTHON PROCESSING ---
      local py_filename = "figures/" .. block.filename .. ".py"
      local updated_code = {}
      local has_savefig = false
      for _, code_line in ipairs(block.code) do
        if code_line:match("plt%.savefig") then
          code_line = string.format('plt.savefig("%s")', pdf_path)
          has_savefig = true
        end
        table.insert(updated_code, code_line)
      end
      if not has_savefig then
        table.insert(updated_code, string.format('plt.savefig("%s")', pdf_path))
      end

      local f = io.open(py_filename, "w")
      if f then
        f:write(table.concat(updated_code, "\n"))
        f:close()
        local output = vim.fn.system(string.format("%s %s", python_cmd, vim.fn.shellescape(py_filename)))
        if vim.v.shell_error == 0 then success = true else err_msg = output end
      end

    elseif block.type == "latex" then
      -- --- LATEX / TIKZ PROCESSING ---
      local tex_filename = "figures/" .. block.filename .. ".tex"
      local raw_code = table.concat(block.code, "\n")
      local full_tex_code = raw_code

      -- Smart Boilerplate: Wrap in standalone class if user didn't write it
      if not raw_code:match("\\documentclass") then
        full_tex_code = table.concat({
          "\\documentclass[tikz,border=2mm]{standalone}",
          "% You can add common packages here if needed (e.g., \\usepackage{pgfplots})",
          "\\begin{document}",
          raw_code,
          "\\end{document}"
        }, "\n")
      end

      local f = io.open(tex_filename, "w")
      if f then
        f:write(full_tex_code)
        f:close()

        -- Compile using xelatex inside the figures directory to keep root clean
        -- -interaction=nonstopmode stops xelatex from hanging on errors
        local cmd = string.format(
          "cd figures && xelatex -interaction=nonstopmode %s",
          vim.fn.shellescape(block.filename .. ".tex")
        )
        local output = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then success = true else err_msg = output end
      end
    end

    -- --- BUFFER REPLACEMENT ---
    if success then
      local replacement = {
        "#figure(",
        string.format('  image("./%s", width: 100%%),', pdf_path),
        string.format('  caption: [%s],', block.caption),
        string.format(")<fig-%s>", block.filename)
      }
      vim.api.nvim_buf_set_lines(buf, block.start_idx - 1, block.end_idx, false, replacement)
    else
      vim.notify(string.format("Error compiling %s:\n%s", block.filename, err_msg), vim.log.levels.ERROR)
    end
  end

  vim.notify("Successfully processed " .. #blocks .. " figure block(s).", vim.log.levels.INFO)
end, {})

local function clean_filename(name)
  local stem, ext = name:match("^(.*)%.([^.]+)$")
  if not stem then
    stem = name
    ext = ""
  else
    ext = "." .. ext
  end
  stem = stem:lower()
  stem = stem:gsub("%s+", "_")
  stem = stem:gsub("[^%w_]", "")
  stem = stem:gsub("__+", "_")
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
