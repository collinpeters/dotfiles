-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Leader key
vim.g.mapleader = " "
vim.g.autoformat = false

vim.opt.winbar = "%=%m %f"

--disabled, this fights project.nvim
--vim.opt.autochdir=true                  -- Change the working directory to that of the current file
vim.opt.autoindent = true -- Automatic indents
vim.opt.cursorcolumn = true -- highlight column on cursor
vim.opt.cursorline = true -- highlight line on cursor
vim.opt.expandtab = true -- Use spaces over tabs
--vim.opt.formatoptions=croql        -- Format options
vim.opt.hidden = true
vim.opt.hlsearch = true -- highlight search matches
vim.opt.ignorecase = true -- Do case insensitive matching
vim.opt.incsearch = true -- Incremental search (find as you type)
--vim.opt.lazyredraw = true -- do not update screen while executing macros
vim.opt.backup = false -- Don't make backup files
vim.opt.wrap = false -- Don't wrap by default
vim.opt.number = true -- Show current line number
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.scrolloff = 3 -- Have 3 lines of offset (or buffer) when scrolling
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.showcmd = true -- Show (partial) command in status line
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.showtabline = 1 -- Show the tab line if there are two or more tabs
vim.opt.smartcase = true -- Do smart case matching
vim.opt.splitbelow = true -- new horizontal split is below, not above
vim.opt.splitright = true -- new vertical split is on right, not left
vim.opt.tabstop = 2 -- Tab stop of 4 characters
vim.opt.textwidth = 120
vim.opt.colorcolumn = "+1"

vim.opt.wildignore:append("*.class") -- Ignore these files

vim.opt.wildmenu = true -- Use the wildmenu
vim.opt.wildmode = "list:longest,full" -- command <Tab> completion, list matches, then longest common part, then all.

-- for nvim-cmp
--vim.opt.completeopt=menuone,noselect

-- disable the auto-indent in yaml files (TODO move this somewhere better)
vim.api.nvim_create_autocmd("FileType", { pattern = "yaml", command = [[setlocal indentkeys-=0#]] })

-- disable markdown concealment (hiding of code block delimiters, etc.)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- https://github.com/vscode-neovim/vscode-neovim/issues/2507#issuecomment-3059712058
if vim.g.vscode then
  vim.opt.cmdheight = 100
end
