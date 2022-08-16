local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua


--https://github.com/onsails/vimway-lsp-diag.nvim

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- colorschemes
  use 'tomasr/molokai'
  use 'tomasiser/vim-code-dark'
  use 'ful1e5/onedark.nvim'
  use 'arcticicestudio/nord-vim'
	use { 'metalelf0/jellybeans-nvim', requires = 'rktjmp/lush.nvim' }
  use 'folke/lsp-colors.nvim' -- fix colorschemes that don't support lsp highlights
  use 'martinsione/darkplus.nvim'

  -- ui
  use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons'}}

  -- formatting/syntax
  use 'NoahTheDuke/vim-just'
  use 'junegunn/vim-easy-align'
  use 'hashivim/vim-terraform'
  use 'jjo/vim-cue'
  --use 'IndianBoy42/tree-sitter-just' -- disabled in favour of manual install, see plugin-configs/tree-sitter-just

  -- Development
  use 'neovim/nvim-lspconfig'
  use 'mfussenegger/nvim-jdtls'
	use 'mfussenegger/nvim-lint'
  use {
    'mfussenegger/nvim-dap', requires = {
      'theHamsta/nvim-dap-virtual-text',
      'rcarriga/nvim-dap-ui',
      'nvim-telescope/telescope-dap.nvim'
    }
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim'}
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
  use { 'nvim-treesitter/nvim-treesitter', branch = '0.5-compat', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use { "ray-x/lsp_signature.nvim" }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
  }
  use 'martinda/Jenkinsfile-vim-syntax'

  -- telescope extensions
  use 'sudormrfbin/cheatsheet.nvim'

  -- completion & snippets
  use {
    "hrsh7th/nvim-cmp",
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
  --use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
  use {
    'preservim/nerdtree' , requires = 
    {
      'Xuyuanp/nerdtree-git-plugin',
      'ryanoasis/vim-devicons',
      'tiagofumo/vim-nerdtree-syntax-highlight'
    }
  }
  use { 'iberianpig/tig-explorer.vim', requires = 'rbgrouleff/bclose.vim' }
  use 'junegunn/fzf.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-unimpaired'
  use 'szw/vim-maximizer'
  use 'famiu/bufdelete.nvim'
  use 'rmagatti/auto-session'

  -- database
  use 'collinpeters/dbext.vim'
  use 'krisajenkins/vim-postgresql-syntax'
  use 'lifepillar/pgsql.vim'
end)
