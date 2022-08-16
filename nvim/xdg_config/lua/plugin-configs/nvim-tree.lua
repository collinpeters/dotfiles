--vim.g.nvim_tree_width = 40
--vim.g.nvim_tree_side = "left"
--vim.g.nvim_open_on_directory = 1
--vim.g.nvim_tree_disable_netrw = 0
--vim.g.nvim_tree_hijack_netrw = 1
--vim.g.nvim_tree_auto_open = 1

-- vim.g.nvim_tree_add_trailing = 1
-- vim.g.nvim_tree_allow_resize = 1
-- vim.g.nvim_tree_auto_ignore_ft = { "dashboard" }
-- vim.g.nvim_tree_auto_open = 1
-- vim.g.nvim_tree_follow = 1
-- vim.g.nvim_tree_git_hl = 1
-- vim.g.nvim_tree_gitignore = 1
-- vim.g.nvim_tree_hide_dotfiles = 0
-- vim.g.nvim_tree_highlight_opened_files = 0
-- vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
-- vim.g.nvim_tree_indent_markers = 0
-- vim.g.nvim_tree_lsp_diagnostics = 0
-- vim.g.nvim_tree_respect_buf_cwd = 1
-- vim.g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }
-- vim.g.nvim_tree_side = "left"
-- vim.g.nvim_tree_update_cwd = 1

require'nvim-tree'.setup {
  -- disables netrw completely
  disable_netrw       = true,
  -- hijack netrw window on startup
  hijack_netrw        = true,
  -- open the tree when running this setup function
  open_on_setup       = false,
  -- will not open on setup if the filetype is in this list
  ignore_ft_on_setup  = {},
  -- closes neovim automatically when the tree is the last **WINDOW** in the view
  auto_close          = true,
  -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
  open_on_tab         = false,
  -- hijacks new directory buffers when they are opened.
  update_to_buf_dir   = {
    -- enable the feature
    enable = false,
    -- allow to open the tree if it was previously closed
    auto_open = true,
  },
  -- hijack the cursor in the tree to put it at the start of the filename
  hijack_cursor       = false,
  -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
  update_cwd          = false,
  -- show lsp diagnostics in the signcolumn
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
  update_focused_file = {
    -- enables the feature
    enable      = false,
    -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
    -- only relevant when `update_focused_file.enable` is true
    update_cwd  = false,
    -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
    -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
    ignore_list = {}
  },
  -- configuration options for the system open command (`s` in the tree by default)
  system_open = {
    -- the command to run this, leaving nil should work in most cases
    cmd  = nil,
    -- the command arguments as a list
    args = {}
  },

  view = {
    -- width of the window, can be either a number (columns) or a string in `%`, for left or right side placement
    width = 40,
    -- height of the window, can be either a number (columns) or a string in `%`, for top or bottom side placement
    height = 40,
    -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
    side = 'left',
    -- if true the tree will resize itself after opening a file
    auto_resize = false,
    mappings = {
      -- custom only false will merge the list with the default mappings
      -- if true, it will only use your list to set the mappings
      custom_only = false,
      -- list of mappings to set on the tree manually
      list = {}
    }
  }
}
