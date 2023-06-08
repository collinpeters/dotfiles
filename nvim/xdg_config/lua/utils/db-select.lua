local M = {}

-- get all keys from table
function getTableKeys(tab)
  local keyset = {}
  for k,v in pairs(tab) do
    keyset[#keyset + 1] = k
  end
  return keyset
end

local databases = dofile('/home/collin/.dadbod.lua')

function M.select()
  local sorters = require "telescope.sorters"
  vim.ui.select(getTableKeys(databases), {
    prompt = "Select a database",
  }, function(db, idx)
    if db then
      print("You selected " .. db .. " at index " .. idx)
      vim.api.nvim_buf_set_var(0, 'db', 'postgresql://mtiq-admin@' .. databases[db] .. ':5432/mtiq')
    else
      print "You cancelled"
    end
  end)
end

return M
