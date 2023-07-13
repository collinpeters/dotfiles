local ok, wk = pcall(require, "which-key")

if not ok then
    return
end



-- Leader is space
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
 
local n_opts = {
    mode = "n",
    prefix = "",
    silent = true,
    noremap = true,
    nowait = true,
}

wk.register({
  ['<Leader>/']= {':set nohlsearch<CR>', 'Clear the search highlights'},

  -- Wrapped lines goes down/up to next row, rather than next line in file (you've fooled me for the last time Vim!!!)
  ['j'] = {'gj'},
  ['k'] = {'gk'},

  -- faster window movement
  -- now powered by vim-tmux-navigator
 --["<C-h>"] = { "<C-w>h", "[WINDOW] Focus in left window" },
 --["<C-j>"] = { "<C-w>j", "[WINDOW] Focus in bottom window" },
 --["<C-k>"] = { "<C-w>k", "[WINDOW] Focus in top window" },
 --["<C-l>"] = { "<C-w>l", "[WINDOW] Focus in right window" },

  -- Last buffer navigation
  [',,'] = { '<c-^>', 'Navigate to last buffer'},

  -- tab to quick switch buffers
  ['<Tab>'] = { ':bnext<CR>' },
  ['<S-Tab>'] = { ':bprev<CR>' },

  -- Make Y behave like C & D (yank to end of line)
  ['Y'] = { 'y$' },

  -- sensible next/previous (keep it in the centre)
  ['n'] = { 'nzzzv'},
  ['N'] = { 'Nzzzv'},

  -- keep cursor for 'J' (join line)
  -- map('n', 'J', 'mzJ`z')

  ["<leader>f"] = {
    name = "[TELESCOPE]",

    f = {'<cmd>Telescope find_files hidden=false no_ignore=true<cr>', "[TELESCOPE] Search for files" },
    r = {'<cmd>Telescope resume<CR>', '[TELESCOPE] Resume previous search' },
    g = {'<cmd>Telescope live_grep<CR>', '[TELESCOPE] Search contents of files' },
    b = {'<cmd>Telescope buffers<CR>', '[TELESCOPE] Search buffers' },
    h = {'<cmd>Telescope help_tags<CR>', '[TELESCOPE] Search vim help tags' },
    p = {'<cmd>Telescope projects<CR>', '[TELESCOPE] Search projects' },
    d = {'<cmd>Telescope file_browser<CR>', '[TELESCOPE] Search file browser' },

    --s = { "<cmd>Telescope grep_string<cr>", "[TELESCOPE] Find files using grep in file names" },
    --m = { "<cmd>Telescope marks<cr>", "[TELESCOPE] Marks" },
    --r = { "<cmd>Telescope oldfiles<cr>", "[TELESCOPE] Recent files" },
    --z = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "[TELESCOPE] Current buffer fuzzy find" },
    --t = { "<cmd>TodoTelescope<cr>", "[TELESCOPE] TODO list" },
    --c = { "<cmd>Telescope command_history<cr>", "[TELESCOPE] Search command history" },
    --x = { "<cmd>Telescope neoclip<cr>", "[TELESCOPE] Search in clipboard manager" },
    --db = { "<cmd>Telescope dap list_breakpoints<cr>", "[TELESCOPE DAP] Breakpoints" },
    --dc = { "<cmd>Telescope dap configurations<cr>", "[TELESCOPE DAP] Debug configurations" },
    --dv = { "<cmd>Telescope dap variables<cr>", "[TELESCOPE DAP] Varibles" },
  },

  ["<leader>"] = {
--    p = { "<cmd>Neotree toggle<cr>", "[NEOTREE] Toggle" },
    t = { "<cmd>TroubleToggle<cr>", "[TROUBLE] Toggle" },
    a = { "<cmd>AerialToggle<cr>", "[AERIAL] Toggle" },
  },

  -- -----------------
  -- LSP KEYMAPPINGS
  -- -----------------
  --['gd'] = { '<cmd>lua vim.lsp.buf.definition()<CR>', '[LSP] Go to definition'},
  ['gd'] = { '<cmd>Telescope lsp_definitions<CR>', '[LSP] Go to definition'},
  --['gi'] = { '<cmd>lua vim.lsp.buf.implementation()<CR>', '[LSP] Go to implementation'},
  ['gi'] = { '<cmd>Telescope lsp_implementations<CR>', '[LSP] Go to implementation'},
  --['gr'] = { '<cmd>lua vim.lsp.buf.references()<CR>', '[LSP] Go to references'},
  ['gr'] = { '<cmd>Telescope lsp_references<CR>', '[LSP] Go to references'},
  --['gK'] = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', '[LSP] Go to definition'},
  ['gK'] = { '<cmd>Telescope lsp_type_definitions<CR>', '[LSP] Go to definition'},
  ['gD'] = { '<cmd>lua vim.lsp.buf.declaration()<CR>', '[LSP] Go to declaration'},  -- not supported by jdtls

  ["<leader>c"] = {
    name = "[LSP]",

    -- find style navigation
    --u =  { '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', '[LSP] Incoming calls'},
    u =  { '<cmd>Telescope lsp_incoming_calls<CR>', '[LSP] Incoming calls'},
    go = { '<cmd>Telescope lsp_outgoing_calls<CR>', '[LSP] Outgoing calls'},

    K =  { '<cmd>lua vim.lsp.buf.hover()<CR>', '[LSP] Hover'},

    m =  { '<cmd>Telescope lsp_document_symbols<CR>', '[LSP] Document symbols'},
    gW = { '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', '[LSP] Workspace symbols'},
  },

  ["<leader>s"] = {
    name = "[SQL/Database]",
  },
-- |
-- |
-- |   -- `code_action` is a superset of vim.lsp.buf.code_action and you'll be able to
-- |   -- use this jdtls mapping also with other non-jdtls language servers
-- |   map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts) -- see jdtls refactor below
-- |   map("n", "<a-CR>", "<Cmd>lua require'jdtls'.code_action()<CR>")
-- |   map("n", "<leader>r", "<Cmd>lua require'jdtls'.code_action(false, 'refactor')<CR>")
-- |   map("v", "<a-CR>", "<Esc><Cmd>lua require'jdtls'.code_action(true)<CR>")
-- |   map("v", "<leader>r", "<Esc><Cmd>lua require'jdtls'.code_action(true, 'refactor')<CR>")

  -- DAP (run/debug)
  ['<f7>'] =    { '<cmd>DapStepInto<CR>', '[DAP] Step into'},
  ['<f8>'] =    { '<cmd>DapStepOver<CR>', '[DAP] Step over'},
  ['<s><f8>'] = { '<cmd>DapStepOut<CR>', '[DAP] Step out'},
  ['<f9>'] =    { '<cmd>DapContinue<CR>', '[DAP] Continue'},
  ["<leader>d"] = {
    name = "[DAP]",
    k = { "<cmd>DapTerminate<cr>", "[DAP] Terminate" },
    b = { "<cmd>DapToggleBreakpoint<cr>", "[DAP] Toggle breakpoint" },
    cb = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "[DAP] Set conditional breakpoint" },
    lb = { "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", "[DAP] Set log point breakpoint" },
    r = { "<cmd>DapToggleRepl", "[DAP] Repl open" },
    l = { "<cmd>lua require'dap'.run_last()<cr>", "[DAP] Run last" },
    o = { "<cmd>lua require'dapui'.open()<cr>", "[DAPUI] Open debugging UI" },
    c = { "<cmd>lua require'dapui'.close()<cr>", "[DAPUI] Close debugging UI" },
  },
-- |
-- |   -- debug
-- |   map('n', '<leader>xl', '<cmd>lua require"dap".run_last()<CR>') -- execute last
-- |   map('n', '<leader>b', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
-- |   map('n', '<leader>B', '<Cmd>lua require"dap".toggle_breakpoint(vim.fn.input("Breakpoint Condition: "), nil, nil, true)<CR>')
-- |   --map('n', '<leader>lp', '<Cmd> require'me.dap'.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '), true)<CR>
-- |
-- |   map('n', '<leader>dc', ':lua require"dap".disconnect({ terminateDebuggee = true });require"dap".close()<CR>')
-- |   map('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
-- |   map('n', '<leader>di', ':lua require"dap.ui.variables".hover()<CR>')
-- |   map('n', '<leader>di', ':lua require"dap.ui.variables".visual_hover()<CR>')
-- |   map('n', '<leader>d?', ':lua require"dap.ui.variables".scopes()<CR>')
-- |   map('n', '<leader>de', ':lua require"dap".set_exception_breakpoints({"all"})<CR>')
-- |   map('n', '<leader>da', ':lua require"debugHelper".attach()<CR>')
-- |   map('n', '<leader>dA', ':lua require"debugHelper".attachToRemote()<CR>')
-- |   map('n', '<leader>di', ':lua require"dap.ui.widgets".hover()<CR>')
-- |   map('n', '<leader>d?', ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>')
-- |   map('n', '<leader>dd', ':lua require"dapui".toggle()<CR>')
-- |
-- |   map('n', "]d", '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
-- |   map('n', "[d", '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
-- |
-- |
-- |     -- jdtls specific maps
-- |     -- api.nvim_buf_set_keymap(bufnr, "n", "<A-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
-- |     -- api.nvim_buf_set_keymap(bufnr, "v", "crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
-- |     -- api.nvim_buf_set_keymap(bufnr, "n", "crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
-- |     -- api.nvim_buf_set_keymap(bufnr, "v", "crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
}, n_opts)

local v_opts = {
    mode = "v",
    nowait = true,
    prefix = "",
    silent = true,
    noremap = true,
}
wk.register({
--    ["jk"] = { "<Esc>", "Normal mode switch" },
--    ["p"] = { '"_dP', "Paste without replacing what is was in clipboard" },

  -- visual shifting (does not exit Visual mode after shift)
  ["<"] = { "<gv", "[Indent] Indent left" },
  [">"] = { ">gv", "[Indent] Indent right" },

  -- move selected line / block of text in visual mode
  ["<A-j>"] = { ":m '>+1<cr>gv=gv", "[MOVE] Move block down" },
  ["<A-k>"] = { ":m '<-2<cr>gv=gv", "[MOVE] Move block up" },
}, v_opts)

wk.setup {}


-- old school mapping
map = function(mode, key, value, description)
  local opts = {noremap = true, silent = true, desc = description}
  --vim.api.nvim_set_keymap(mode,key,value,opts);
  vim.keymap.set(mode,key,value,opts);
end


-- Copy & paste to system clipboard with <leader>p and <leader>y:
map('v', '<Leader>y', '"+y', 'Yank (Copy to system clipboard)')
map('v', '<Leader>d', '"+d', 'Delete (Copy to system clipboard)')
map('n', '<Leader>p', '"+p', 'Paste from system clipboard')
map('n', '<Leader>P', '"+P', 'Paste above from system clipboard')
map('v', '<Leader>p', '"+p', 'Paste from system clipboard')
map('v', '<Leader>P', '"+P', 'Paste above from system clipboard')

-- SQL/Database
map('n', '<Leader>ss',  "<Cmd>lua require'utils.db-select'.select()<Cr>", "[SQL] Database Selection")
map('n', '<Leader>se',  '<cmd><Plug>(DBExe)<CR>',                         '[SQL] Execute')
map('n', '<Leader>sea', '<cmd><Plug>(DBExeAll)<CR>',                      '[SQL] Execute all')
map('n', '<Leader>sel', '<cmd><Plug>(DBExeLine)<CR>',                     '[SQL] Execute line')
map('v', '<Leader>sd',  '<cmd><Plug>(DBDescribe)<CR>',                    '[SQL] Describe Table')

-- | -- undo breakpoints
-- | map('i', '.', '.<c-g>u')
-- | map('i', ',', ',<c-g>u')
-- | map('i', '!', '!<c-g>u')
-- | map('i', '?', '?<c-g>u')
-- |
-- |     --
-- | -- vim.lsp.buf.clear_references()
-- | -- vim.lsp.buf.completion()
-- | -- vim.lsp.buf.document_highlight()
-- | -- vim.lsp.buf.formatting()
-- | -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
-- | -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
-- | -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
-- | -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
-- | -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
-- | -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
-- | -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
-- | -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts) 
-- |    
-- | --
-- | -- --	" LSP config (the mappings used in the default file don't quite work right)
-- | -- --	nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
-- | -- --	nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
-- | --
-- | -- --
-- | -- -- nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
-- | -- -- nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
-- | -- -- vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
-- | -- -- nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
-- | -- -- vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
-- | -- -- vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>
-- |
-- | -- -----------------
-- | -- PLUGIN KEYMAPPINGS
-- | -- -----------------
-- |
-- |
-- | --  -- windows/panes/tabs/buffers
-- | --  map('n', '<Leader>v', ':vsplit<CR>', { noremap = true, silent = true })
-- | --  map('n', '<Leader>s', ':split<CR>', { noremap = true, silent = true })
-- | --  map('n', '<Leader>o', ':only<CR>', { noremap = true, silent = true })
-- | --  map('n', '<Leader>t', ':tabnew<CR>', { noremap = true, silent = true })
-- |

