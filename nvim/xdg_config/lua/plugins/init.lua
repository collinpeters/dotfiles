local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
        install_path }
end
vim.cmd [[packadd packer.nvim]]

local ok, packer = pcall(require, "packer")

if not ok then
    return
end

--vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float {
                border = "single"
            }
        end,
        prompt_border = "single"
    },
    git = {
        clone_timeout = 600
    },
    auto_clean = true,
    compile_on_sync = false
}


--https://github.com/onsails/vimway-lsp-diag.nvim
-- require('plugins.configs.lspsaga')
-- require('plugins.configs.luasnips')

require("packer").startup(function(use)
  -- Utilities
  use 'wbthomason/packer.nvim' -- Neovim plugin management (this file) Packer can manage itself
  use "lewis6991/impatient.nvim" -- Startup performance enhancer
  use {
    "williamboman/mason.nvim", -- Tooling package manager
    config = require "plugins.configs.mason"
  }
  use { "folke/which-key.nvim" }

  -- colorschemes
  use 'arcticicestudio/nord-vim'
  use 'tomasr/molokai'
  use 'tomasiser/vim-code-dark'
  use 'ful1e5/onedark.nvim'
  use 'folke/lsp-colors.nvim' -- fix colorschemes that don't support lsp highlights
  use 'martinsione/darkplus.nvim'
  use 'https://gitlab.com/__tpb/monokai-pro.nvim'

  -- ui
  use {
    'nvim-lualine/lualine.nvim',
    config = require('plugins.configs.lualine'),
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- formatting/syntax
  use 'NoahTheDuke/vim-just'
  use 'junegunn/vim-easy-align'
  use 'hashivim/vim-terraform'
  use 'jjo/vim-cue'
  use 'towolf/vim-helm'
  --use 'IndianBoy42/tree-sitter-just' -- disabled in favour of manual install, see plugins.configs/tree-sitter-just
-- require('plugins.configs.treesitter-just')

  -- Development
  --use 'neovim/nvim-lspconfig'
  use 'mfussenegger/nvim-jdtls'
  use {
    'mfussenegger/nvim-lint',
    config = require('plugins.configs.nvim-lint'),
  }
  use {
    'mfussenegger/nvim-dap',
    requires = {
      'theHamsta/nvim-dap-virtual-text',
    }
  }
  use {
    'nvim-telescope/telescope.nvim',
    config = require('plugins.configs.telescope'),
    requires = {'nvim-lua/plenary.nvim'}
  }
  use {
    'rcarriga/nvim-dap-ui',
    config = require('plugins.configs.dapui'),
    requires = {
      'nvim-telescope/telescope-dap.nvim',
  }
  }
  use {
    "folke/trouble.nvim",
    config = require('plugins.configs.trouble'),
    requires = "kyazdani42/nvim-web-devicons",
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = require('plugins.configs.nvim-treesitter'),
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/playground'
  use { "ray-x/lsp_signature.nvim" }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
  }
  use 'martinda/Jenkinsfile-vim-syntax'
  use({
    "stevearc/aerial.nvim",
    config = function()
      require("plugins.config.aerial").setup()
    end,
  })

  use 'RRethy/vim-illuminate'

  -- telescope extensions
  use 'sudormrfbin/cheatsheet.nvim'
  use { 'nvim-telescope/telescope-dap.nvim', }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  use { 'nvim-telescope/telescope-file-browser.nvim', }
  use { 'nvim-telescope/telescope-ui-select.nvim', }

  -- completion & snippets
  use {
    "hrsh7th/nvim-cmp",
    config = require('plugins.configs.cmp'),
    requires = {
      "hrsh7th/cmp-buffer", -- completion sources from buffer
      "hrsh7th/cmp-nvim-lsp", -- completion sources from lsp
      "onsails/lspkind-nvim", -- add pictograms to lsp suggestions
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- cmp/luasnip bridge
      "rafamadriz/friendly-snippets", -- snippets for luasnip
    }
  }

  -- utility
  use 'preservim/nerdtree'
  -- use {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "v2.x",
  --   config = require('plugins.configs.neo-tree'),
  --   requires = { 
  --     "nvim-lua/plenary.nvim",
  --     "kyazdani42/nvim-web-devicons",
  --     "MunifTanjim/nui.nvim",
  --   }
  -- }
  use { 'iberianpig/tig-explorer.vim', requires = 'rbgrouleff/bclose.vim' }
  use 'junegunn/fzf.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-unimpaired'
  use 'szw/vim-maximizer'
  use 'famiu/bufdelete.nvim'
  use 'rmagatti/auto-session'

  -- Database
  use {
    "collinpeters/vim-dadbod", -- personal fork
    requires = {
      "kristijanhusak/vim-dadbod-completion",
    },
    config = require('plugins.configs.dadbod').setup(),
  }
  use {
    'lifepillar/pgsql.vim',
    config = require('plugins.configs.pgsql')
  }
end)
