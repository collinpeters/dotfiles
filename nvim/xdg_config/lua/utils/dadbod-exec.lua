local M = {}

-- Execute text by writing to temp file and using DB with file input
local function execute_text(text)
  print("=== DADBOD DEBUG ===")
  print("Text to execute: " .. vim.inspect(text))

  -- Create a temporary file
  local tmpfile = vim.fn.tempname() .. '.sql'
  print("Temp file: " .. tmpfile)

  -- Write the text to the temp file
  local lines = vim.split(text, '\n')
  vim.fn.writefile(lines, tmpfile)

  -- Verify file contents
  local written = vim.fn.readfile(tmpfile)
  print("File contents: " .. vim.inspect(written))

  -- Execute using DB with file input (< syntax)
  local cmd = '<' .. tmpfile
  print("Command to execute: DB " .. cmd)
  print("Calling db#execute_command with: ('', 0, -1, 0, '" .. cmd .. "')")

  local result = vim.fn['db#execute_command']('', 0, -1, 0, cmd)
  print("Result: " .. vim.inspect(result))
  print("===================")

  -- Clean up temp file after a delay (dadbod reads it asynchronously)
  vim.defer_fn(function()
    vim.fn.delete(tmpfile)
  end, 1000)
end

-- Execute visually selected text as DB query
function M.execute_visual()
  -- Save current register
  local reg_save = vim.fn.getreg('"')
  local regtype_save = vim.fn.getregtype('"')

  -- Yank visual selection
  vim.cmd('normal! gvy')
  local query = vim.fn.getreg('"')

  -- Restore register
  vim.fn.setreg('"', reg_save, regtype_save)

  -- Execute the query
  execute_text(query)
end

-- Execute current line as DB query
function M.execute_line()
  local line = vim.fn.getline('.')
  execute_text(line)
end

-- Execute entire buffer as DB query
function M.execute_all()
  local lines = vim.fn.getline(1, '$')
  local query = table.concat(lines, '\n')
  execute_text(query)
end

-- Describe table (visual selection is table name)
function M.describe_table()
  -- Save current register
  local reg_save = vim.fn.getreg('"')
  local regtype_save = vim.fn.getregtype('"')

  -- Yank visual selection
  vim.cmd('normal! gvy')
  local table_name = vim.fn.getreg('"')

  -- Execute describe command
  vim.cmd('DB \\d+ ' .. table_name)

  -- Restore register
  vim.fn.setreg('"', reg_save, regtype_save)
end

-- Count table (visual selection is table name)
function M.count_table()
  -- Save current register
  local reg_save = vim.fn.getreg('"')
  local regtype_save = vim.fn.getregtype('"')

  -- Yank visual selection
  vim.cmd('normal! gvy')
  local table_name = vim.fn.getreg('"')

  -- Execute count command
  vim.cmd('DB SELECT count(*) AS exact_count FROM ' .. table_name)

  -- Restore register
  vim.fn.setreg('"', reg_save, regtype_save)
end

return M
