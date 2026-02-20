local M = {}

--- Build a connection URL from a database config entry.
---@param cfg table { url, username, database, port?, dbtype? }
---@return string
local function build_url(cfg)
  local dbtype = cfg.dbtype or "postgresql"
  local port = cfg.port or "5432"
  return dbtype .. "://" .. cfg.username .. "@" .. cfg.url .. ":" .. port .. "/" .. cfg.database
end

--- Load databases from ~/.dadbod.lua and present a picker.
function M.select()
  local ok, databases = pcall(dofile, os.getenv("HOME") .. "/.dadbod.lua")
  if not ok or type(databases) ~= "table" then
    vim.notify("Failed to load ~/.dadbod.lua", vim.log.levels.ERROR)
    return
  end

  local names = vim.tbl_keys(databases)
  table.sort(names)

  vim.ui.select(names, { prompt = "Select a database" }, function(choice)
    if not choice then
      vim.notify("Cancelled", vim.log.levels.INFO)
      return
    end
    local url = build_url(databases[choice])
    vim.b.db = url
    vim.notify("DB: " .. choice, vim.log.levels.INFO)
  end)
end

--- Get the visually selected text with column-level precision.
---@return string
local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_row = start_pos[2]
  local start_col = start_pos[3]
  local end_row = end_pos[2]
  local end_col = end_pos[3]

  -- Normalize if selection was made backwards
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local lines = vim.fn.getline(start_row, end_row)
  if type(lines) == "string" then
    lines = { lines }
  end

  if #lines == 0 then
    return ""
  end

  -- V-line selection: end_col is v:maxcol, just return full lines
  if end_col >= 2147483647 then
    return table.concat(lines, "\n")
  end

  -- Trim to the selected columns
  -- end_col is 1-indexed inclusive from getpos
  lines[#lines] = string.sub(lines[#lines], 1, end_col)
  lines[1] = string.sub(lines[1], start_col)

  return table.concat(lines, "\n")
end

--- Ensure vim-dadbod is loaded (handles lazy loading).
local function ensure_dadbod()
  if vim.fn.exists(":DB") ~= 2 then
    require("lazy").load({ plugins = { "vim-dadbod" } })
  end
end

--- Execute a SQL string through dadbod.
--- Uses a temp file to avoid any range/escaping issues with :DB.
---@param sql string
local function db_exec(sql)
  if not vim.b.db or vim.b.db == "" then
    vim.notify("No database selected. Use <leader>ds first.", vim.log.levels.WARN)
    return
  end
  ensure_dadbod()
  local tmpfile = vim.fn.tempname() .. ".sql"
  local lines = vim.split(sql, "\n")
  vim.fn.writefile(lines, tmpfile)
  -- Call db#execute_command directly: mods, bang, line1, line2, cmd
  -- line2=-1 means "no range" which takes the direct-command path
  vim.fn["db#execute_command"]("", 0, 0, -1, "< " .. tmpfile)
  -- Clean up after dadbod has had time to read the file
  vim.defer_fn(function()
    vim.fn.delete(tmpfile)
  end, 10000)
end

--- Execute the visual selection as a SQL query.
function M.execute_visual()
  local sql = get_visual_selection()
  db_exec(sql)
end

--- Execute the current line as a SQL query.
function M.execute_line()
  local sql = vim.fn.getline(".")
  db_exec(sql)
end

--- Execute the entire buffer as a SQL query.
function M.execute_all()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local sql = table.concat(lines, "\n")
  db_exec(sql)
end

--- Describe the visually selected table name (psql \d+).
function M.describe_table()
  local table_name = vim.trim(get_visual_selection())
  if not vim.b.db or vim.b.db == "" then
    vim.notify("No database selected. Use <leader>ds first.", vim.log.levels.WARN)
    return
  end
  ensure_dadbod()
  -- line1 must be non-zero so dadbod takes the direct-command path (line 523-524)
  -- rather than the "use current file" path (line 521-522)
  vim.fn["db#execute_command"]("", 0, 1, -1, "\\d+ " .. table_name)
end

--- Count rows in the visually selected table name.
function M.count_table()
  local table_name = vim.trim(get_visual_selection())
  if not vim.b.db or vim.b.db == "" then
    vim.notify("No database selected. Use <leader>ds first.", vim.log.levels.WARN)
    return
  end
  ensure_dadbod()
  vim.fn["db#execute_command"]("", 0, 1, -1, "SELECT count(*) AS exact_count FROM " .. table_name)
end

return M
