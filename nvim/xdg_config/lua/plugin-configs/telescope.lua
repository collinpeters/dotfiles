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
  },
}
