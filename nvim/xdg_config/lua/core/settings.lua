local set = vim.opt

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

vim.g.ale_java_checkstyle_config="/home/collin/Code/sonatype/1/codestyle/checkstyle-checks/src/main/resources/sonatype/checkstyle-configuration.xml"
vim.g.ale_java_eclipselsp_path="/usr/share/java/jdtls"
vim.g.ale_java_eclipselsp_config_path="/usr/share/java/jdtls/config_linux/"
vim.g.ale_java_eclipselsp_workspace_path="/home/collin/Code/workspace/"
--vim.g.ale_linters = {'java': ['eclipselsp']}
-- vim.cmd [[
-- let b:ale_linters = ['eclipselsp']
-- ]]
