map = function(mode, key, value)
	local opts = {noremap = true, silent = true}
	vim.api.nvim_set_keymap(mode,key,value,opts);
end

-- Leader is space
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
 
-- Copy & paste to system clipboard with <leader>p and <leader>y:
map('v', '<Leader>y', '"+y')
map('v', '<Leader>d', '"+d')
map('n', '<Leader>p', '"+p')
map('n', '<Leader>P', '"+P')
map('v', '<Leader>p', '"+p')
map('v', '<Leader>P', '"+P')

-- Clear the search. No more typing '/asdfawdsf' to clear the search
map('n', '<Leader>/', ':set nohlsearch<CR>')

-- Wrapped lines goes down/up to next row, rather than next line in file (you've fooled me for the last time Vim!!!)
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- visual shifting (does not exit Visual mode after shift)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- faster window movement
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
--map('n', '<Leader>bk', ':bdelete<CR>', { silent = true })

-- move selected line / block of text in visual mode
map('v', 'K', ':move \'<-2<CR>gv-gv')
map('v', 'J', ':move \'>+1<CR>gv-gv')

-- Last buffer navigation
map('n', ',,', '<c-^>')

-- tab to quick switch buffers
map('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
map('n', '<S-Tab>', ':bprev<CR>', { noremap = true, silent = true })

-- Make Y behave like C & D (yank to end of line)
map('n', 'Y', 'y$')

-- sensible next/previous (keep it in the centre)
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- keep cursor for 'J' (join line)
-- map('n', 'J', 'mzJ`z')

-- undo breakpoints
map('i', '.', '.<c-g>u')
map('i', ',', ',<c-g>u')
map('i', '!', '!<c-g>u')
map('i', '?', '?<c-g>u')

-- -----------------
-- PLUGIN KEYMAPPINGS
-- -----------------

-- telescope
map('n', '<Leader>fr', '<cmd>Telescope resume<CR>')
map('n', '<Leader>ff', '<cmd>Telescope find_files<CR>')
map('n', '<Leader>fg', '<cmd>Telescope live_grep<CR>')
map('n', '<Leader>fb', '<cmd>Telescope buffers<CR>')
map('n', '<Leader>fh', '<cmd>Telescope help_tags<CR>')
map('n', '<Leader>fp', '<cmd>Telescope projects<CR>')

--  explorer
map('n', '<Leader>e', ':NERDTreeToggle<CR>')


--  -- windows/panes/tabs/buffers
--  map('n', '<Leader>v', ':vsplit<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>s', ':split<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>o', ':only<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>t', ':tabnew<CR>', { noremap = true, silent = true })
