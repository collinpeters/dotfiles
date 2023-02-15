local set = vim.opt

-- disable mouse
vim.opt.mouse=''

--disabled, this fights project.nvim
--set.autochdir=true                  -- Change the working directory to that of the current file
set.autoindent=true                 -- Automatic indents
set.cursorcolumn=true               -- highlight column on cursor
set.cursorline=true                 -- highlight line on cursor
set.expandtab=true                  -- Use spaces over tabs
--set.formatoptions=croql        -- Format options
set.hidden=true
set.hlsearch=true                   -- highlight search matches
set.ignorecase=true                 -- Do case insensitive matching
set.incsearch=true                 -- Incremental search (find as you type)
set.lazyredraw=true                -- do not update screen while executing macros
set.backup=false                  -- Don't make backup files
set.wrap=false                    -- Don't wrap by default
set.number=true                    -- Show current line number
set.pastetoggle="<F2>"           -- Handle the paste toggle when pasting code
set.relativenumber=true            -- Show relative line numbers
set.scrolloff=3                -- Have 3 lines of offset (or buffer) when scrolling
set.shiftwidth=2               -- Number of spaces to use for each step of (auto)indent
set.showcmd=true                   -- Show (partial) command in status line
set.showmatch=true                 -- Highlight matching brackets
set.showtabline=1              -- Show the tab line if there are two or more tabs
set.smartcase=true                 -- Do smart case matching
set.splitbelow=true                -- new horizontal split is below, not above
set.splitright=true                -- new vertical split is on right, not left
set.tabstop=2                  -- Tab stop of 4 characters
set.textwidth=120
set.colorcolumn="+1"


vim.opt.wildignore:append('*.class')        -- Ignore these files

set.wildmenu=true                   -- Use the wildmenu
set.wildmode="list:longest,full" -- command <Tab> completion, list matches, then longest common part, then all.

-- for nvim-cmp
--set.completeopt=menuone,noselect


--let g:dap_virtual_text = v:true
--vim.g.dap_virtual_text=true

-- disable the auto-indent in yaml files (TODO move this somewhere better)
local api = vim.api
api.nvim_create_autocmd("FileType", { pattern = "yaml", command = [[setlocal indentkeys-=0#]] })
