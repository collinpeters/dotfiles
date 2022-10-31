local _telescope, telescope = pcall(require, "telescope")

if not _telescope then
  print("Failed to load telescope.lua")
  return
end

local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    path_display = { 'truncate' },
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
    preview = {
      treesitter = false,
    },
    layout_config = {
      horizontal = { width = 0.95, height = 0.95 }
      -- other layout configuration here
    },
  },
}

-- load telescope extensions
require('telescope').load_extension('dap')
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
require("telescope").load_extension("ui-select")
