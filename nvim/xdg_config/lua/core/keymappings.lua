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
map('v', 'K', ':move \'<-2<CR>gv-gv', { noremap = true, silent = true })
map('v', 'J', ':move \'>+1<CR>gv-gv', { noremap = true, silent = true })

-- BUFFER navigation
map('n', ',,', '<c-^>')

-- Make Y behave like C & D (yank to end of line)
map('n', 'Y', 'y$')

-- sensible next/previous (keep it in the centre)
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- keep curosor for 'J' (join line)
map('n', 'J', 'mzJ`z')

-- undo breakpoints
map('i', '.', '.<c-g>u')
map('i', ',', ',<c-g>u')
map('i', '!', '!<c-g>u')
map('i', '?', '?<c-g>u')

-- -----------------
-- PLUGIN KEYMAPPINGS
-- -----------------

-- telescope
map('n', '<Leader>ff', '<cmd>Telescope find_files<CR>')
map('n', '<Leader>fg', '<cmd>Telescope live_grep<CR>')
map('n', '<Leader>fb', '<cmd>Telescope buffers<CR>')
map('n', '<Leader>fh', '<cmd>Telescope help_tags<CR>')
map('n', '<Leader>fp', '<cmd>Telescope projects<CR>')
-- fzy
--map('n', '<Leader>ff', '<cmd>lua require("fzy").execute("fd", fzy.sinks.edit_file)<CR>')
--map('n', '<Leader>fb', '<cmd>lua require("fzy").actions.buffers()<CR>')
--map('n', '<Leader>ft', '<cmd>lua require("fzy").try(fzy.actions.lsp_tags, fzy.actions.buf_tags)<CR>')
--map('n', '<Leader>fg', '<cmd>lua require("fzy").execute("git ls-files", fzy.sinks.edit_file)<CR>')
--map('n', '<Leader>fq', '<cmd>lua require("fzy").actions.quickfix()<CR>')
--map('n', '<Leader>f/', '<cmd>lua require("fzy").actions.buf_lines()<CR>')

--  -- explorer
map('n', '<Leader>e', ':NERDTreeToggle<CR>')

-- lsp: see lua/lsp/conf.lua

--	"   " compe
--	"   set completeopt=menuone,noselect
--	"   
--	"   
--	"   inoremap <silent><expr> <C-Space> compe#complete()
--	"   inoremap <silent><expr> <CR>      compe#confirm('<CR>')
--	"   inoremap <silent><expr> <C-e>     compe#close('<C-e>')
--	"   inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
--	"   inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
-- -----------------
-- EOF
-- -----------------

-- If using nvim-dap
-- This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
--nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
--nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>

-- 
-- 
-- 
-- 
--  -- tab switch buffer
--  map('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
--  map('n', '<S-Tab>', ':bprev<CR>', { noremap = true, silent = true })
-- 
--  -- spell correction
--  map('i', '<C-l>', '<C-g>u<Esc>[s1z=`]a<C-g>u', { noremap = true, silent = true })
-- 
--  -- highlight everything
--  map('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
--  map('i', '<C-a>', '<Esc>ggVG', { noremap = true, silent = true })
-- 
--  -- windows/panes/tabs/buffers
--  map('n', '<Leader>v', ':vsplit<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>s', ':split<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>o', ':only<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>t', ':tabnew<CR>', { noremap = true, silent = true })
--    
--  -- git
--  map('n', '<Leader>gs', ':Gstatus<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gd', ':Gdiffsplit<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gc', ':Gcommit<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gp', ':Gpush<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gP', ':Gpull<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gm', ':Gmove<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gM', ':Gmerge<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gb', ':Gbrowse<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>gb', ':Gbrowse<CR>', { noremap = true, silent = true })
-- 
--  -- translate
--  map('n', '<Leader>t', ':Translate<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>tw', ':TranslateW<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>tr', ':TranslateR<CR>', { noremap = true, silent = true })
-- 
--  -- vimtex
--  map('n', '<Leader>lc', ':VimtexCompile<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>ls', ':VimtexCompileSelected<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>li', ':VimtexInfo<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>lt', ':VimtexTocToggle<CR>', { noremap = true, silent = true })
--  map('n', '<Leader>lv', ':VimtexView<CR>', { noremap = true, silent = true })
-- 
--  -- markdown
--  map('n', '<Leader>md', ':MarkdownPreview<CR>', { noremap = true, silent = true })
