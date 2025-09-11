-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- disable LazyVim override of shift-h & shift-l for buffer switching
-- defaults for top/bottom of file
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Clear the search buffer
vim.keymap.set("n", "<leader>/", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- System clipboard mappings
vim.keymap.set("v", "<leader>y", '"+y', { desc = "System copy" })
vim.keymap.set("v", "<leader>d", '"+d', { desc = "System cut" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "System paste after" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "System paste before" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "System paste after" })
vim.keymap.set("v", "<leader>P", '"+P', { desc = "System paste before" })

-- delete snacks profile keymaps as they conflict with custom db keymaps
vim.keymap.del("n", "<leader>dph")
vim.keymap.del("n", "<leader>dpp")
vim.keymap.del("n", "<leader>dps")

-- VS Code - specifics for if we are in VS Code or NOT in VS Code
-- stylua: ignore start
if not vim.g.vscode then
  -- Todo
end

if vim.g.vscode then
  -- Helper function to call VSCode commands
  local vscode = require("vscode")

  -- Open/search/find mappings
  vim.keymap.set('n', '<leader>oe', function() vscode.call('workbench.action.showCommands') end, { desc = 'Search everywhere' })
  vim.keymap.set('n', '<leader>oa', function() vscode.call('workbench.action.showCommands') end, { desc = 'Go to action' })
  vim.keymap.set('n', '<leader>oc', function() vscode.call('workbench.action.showAllSymbols') end, { desc = 'Go to class' })
  vim.keymap.set('n', '<leader>of', function() vscode.call('workbench.action.quickOpen') end, { desc = 'Go to file' })
  vim.keymap.set('n', '<leader>og', function() vscode.call('workbench.action.findInFiles') end, { desc = 'Find in path' })
  vim.keymap.set('n', '<leader>or', function() vscode.call('workbench.action.openRecent') end, { desc = 'Recent files' })
  vim.keymap.set('n', '<leader>os', function() vscode.call('workbench.action.gotoSymbol') end, { desc = 'Go to symbol' })

  -- Navigate -> goto/jumps
  -- Go to definition - LazyVim default: gd
  -- Go to references - LazyVim default: gr
  -- Go to implementation - LazyVim default: gI
  -- Go to t[y]pe definition - LazyVim default: gy
  -- Go to declaration - LazyVim default: gD
  -- vim.keymap.set('n', '<leader>gd', function() vscode.call('editor.action.revealDefinition') end, { desc = 'Goto definition' })
  -- vim.keymap.set('n', '<leader>gK', function() vscode.call('editor.action.goToTypeDefinition') end, { desc = 'Goto type definition' })
  -- vim.keymap.set('n', '<leader>gi', function() vscode.call('editor.action.revealDefinition') end, { desc = 'Goto implementation' })
  -- vim.keymap.set('n', '<leader>gs', function() vscode.call('editor.action.goToReferences') end, { desc = 'Goto super method' })
  vim.keymap.set('n', '<leader>gt', function() vscode.call('java.test.goToTest') end, { desc = 'Goto test' })
  -- vim.keymap.set('n', '<leader>gl', function() vscode.call('editor.action.goToReferences') end, { desc = 'Goto related' })

  -- Navigate -> windows/dialogs
  vim.keymap.set('n', '<leader>m', function() vscode.call('workbench.action.gotoSymbol') end, { desc = 'File structure' })
  vim.keymap.set('n', '<leader>u', function() vscode.call('references-view.findReferences') end, { desc = 'Find usages' })

  -- Show (in sidebar)
  vim.keymap.set('n', '<leader>sh', function() vscode.call('references-view.showCallHierarchy') end, { desc = 'Call hierarchy' })
  vim.keymap.set('n', '<leader>st', function() vscode.call('references-view.showTypeHierarchy') end, { desc = 'Type hierarchy' })
  vim.keymap.set('n', '<leader>ss', function() vscode.call('outline.focus') end, { desc = 'Structure view' })
  vim.keymap.set('n', '<leader>sd', function() vscode.call('workbench.scm.focus') end, { desc = 'Show diff' })

  -- Code formatting
  vim.keymap.set('n', '<leader>f', function() 
    vscode.call('editor.action.formatDocument')
    vscode.call('editor.action.organizeImports')
  end, { desc = 'Format code and organize imports' })

  -- NERDTree equivalent (Explorer)
  vim.keymap.set('n', '<leader>t', function() vscode.call('workbench.files.action.showActiveFileInExplorer') end, { desc = 'Goto project window' })

  -- Refactor
  vim.keymap.set('n', '<leader>rr', function() vscode.call('editor.action.rename') end, { desc = 'Rename element' })

  -- Execute - run/debug
  vim.keymap.set('n', '<leader>xb', function() vscode.call('editor.debug.action.toggleBreakpoint') end, { desc = 'Toggle breakpoint' })
  vim.keymap.set('n', '<leader>xr', function() vscode.call('workbench.action.debug.run') end, { desc = 'Run previous' })
  vim.keymap.set('n', '<leader>xR', function() vscode.call('java.debug.runJavaFile') end, { desc = 'Run current class' })
  vim.keymap.set('n', '<leader>xd', function() vscode.call('workbench.action.debug.start') end, { desc = 'Debug previous' })
  vim.keymap.set('n', '<leader>xD', function() vscode.call('java.debug.debugJavaFile') end, { desc = 'Debug current class' })
  vim.keymap.set('n', '<leader>xc', function() vscode.call('workbench.action.debug.selectandstart') end, { desc = 'Choose run configuration' })
  vim.keymap.set('n', '<leader>xC', function() vscode.call('workbench.action.debug.selectandstart') end, { desc = 'Choose debug configuration' })

  -- Build (Java/Maven specific - adjust based on your project type)
  vim.keymap.set('n', '<leader>bc', function() vscode.call('java.compile.workspace') end, { desc = 'Compile file' })
  vim.keymap.set('n', '<leader>bd', function() vscode.call('java.compile.workspace') end, { desc = 'Compile dirty files' })
  vim.keymap.set('n', '<leader>bp', function() vscode.call('java.compile.workspace') end, { desc = 'Compile project' })

  -- Windows
  vim.keymap.set('n', '<leader>wM', function() vscode.call('workbench.view.extensions') end, { desc = 'Activate Maven tool window' })
  vim.keymap.set('n', '<leader>wm', function() vscode.call('java.projectConfiguration.update') end, { desc = 'Maven reimport' })
  vim.keymap.set('n', '<leader>wd', function() vscode.call('workbench.view.debug') end, { desc = 'Activate debug tool window' })
  vim.keymap.set('n', '<leader>wr', function() vscode.call('workbench.action.output.toggleOutput') end, { desc = 'Activate run tool window' })
  vim.keymap.set('n', '<leader>wp', function() vscode.call('workbench.action.quickSwitchWindow') end, { desc = 'Next project window' })
  vim.keymap.set('n', '<leader>wP', function() vscode.call('workbench.action.openRecent') end, { desc = 'Recent projects window' })
  vim.keymap.set('n', '<leader>wh', function() vscode.call('workbench.action.closePanel') end, { desc = 'Hide all windows' })
  vim.keymap.set('n', '<leader>wt', function() vscode.call('workbench.action.moveEditorToNextGroup') end, { desc = 'Move editor to opposite tab group' })

  -- Move lines up and down
  vim.keymap.set('n', '<C-Up>', function() vscode.call('editor.action.moveLinesUpAction') end, { desc = 'Move line up' })
  vim.keymap.set('n', '<C-Down>', function() vscode.call('editor.action.moveLinesDownAction') end, { desc = 'Move line down' })
  vim.keymap.set('v', '<C-Up>', function() vscode.call('editor.action.moveLinesUpAction') end, { desc = 'Move lines up' })
  vim.keymap.set('v', '<C-Down>', function() vscode.call('editor.action.moveLinesDownAction') end, { desc = 'Move lines down' })

  -- Unimpaired mappings
  vim.keymap.set('n', '[<leader>', function() vscode.call('workbench.action.navigateBack') end, { desc = 'Navigate back' })
  vim.keymap.set('n', ']<leader>', function() vscode.call('workbench.action.navigateForward') end, { desc = 'Navigate forward' })
  vim.keymap.set('n', '[q', function() vscode.call('editor.action.marker.prevInFiles') end, { desc = 'Previous occurrence' })
  vim.keymap.set('n', ']q', function() vscode.call('editor.action.marker.nextInFiles') end, { desc = 'Next occurrence' })
  vim.keymap.set('n', '[m', function() vscode.call('cursorMove', { to = 'prevBlankLine' }) end, { desc = 'Method up' })
  vim.keymap.set('n', ']m', function() vscode.call('cursorMove', { to = 'nextBlankLine' }) end, { desc = 'Method down' })
  vim.keymap.set('n', '[c', function() vscode.call('workbench.action.editor.previousChange') end, { desc = 'Previous change marker' })
  vim.keymap.set('n', ']c', function() vscode.call('workbench.action.editor.nextChange') end, { desc = 'Next change marker' })
  vim.keymap.set('n', '[f', function() vscode.call('editor.action.marker.prevInFiles') end, { desc = 'Go to previous error' })
  vim.keymap.set('n', ']f', function() vscode.call('editor.action.marker.nextInFiles') end, { desc = 'Go to next error' })
  vim.keymap.set('n', '[e', function() vscode.call('workbench.action.compareEditor.previousChange') end, { desc = 'Jump to next change' })
  vim.keymap.set('n', ']e', function() vscode.call('workbench.action.compareEditor.nextChange') end, { desc = 'Jump to last change' })

  -- Git mappings
  vim.keymap.set('n', '<leader>Gd', function() vscode.call('git.openChange') end, { desc = 'Git diff' })

  -- Reselect visual selection after indenting
  vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
  vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

  -- ----------------
  -- Additional VSCode-Neovim specific settings

  -- Ensure VSCode handles certain key combinations
  -- Note: In VSCode-Neovim, some of these might need to be configured in VSCode settings.json
  -- Add these to your VSCode settings.json if needed:
  --   "vscode-neovim.ctrlKeysForNormalMode": ["<C-h>", "<C-j>", "<C-k>", "<C-l>"]

  -- Optional: Enable which-key equivalent using legendary.nvim or which-key.nvim
  -- You'll need to install these as Neovim plugins separately
  -- Example with which-key.nvim:
  -- require("which-key").setup({})
end
-- stylua: ignore end
