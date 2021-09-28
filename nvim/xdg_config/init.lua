-- Core Settings
require('core.plugins')
require('core.keymappings')
require('core.settings')
require('core.colorscheme')

-- Plugins
require('plugin-configs.lspsaga')
require('plugin-configs.bufferline')
require('plugin-configs.lualine')
require('plugin-configs.nvim-treesitter')
require('plugin-configs.treesitter-just')
require('plugin-configs.trouble')
require('plugin-configs.luasnips')
require('plugin-configs.nvim-cmp')
require('plugin-configs.nvim-tree')
require('plugin-configs.vista')
require('plugin-configs.telescope')
require('plugin-configs.telescope-fzf-native')
--require('plugin-configs.navigator')

-- LSP
require('lsp')
