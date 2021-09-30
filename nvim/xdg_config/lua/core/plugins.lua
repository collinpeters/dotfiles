local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- colorschemes
  -- use 'tomasr/molokai'
  use 'tomasiser/vim-code-dark'
  use 'arcticicestudio/nord-vim'
  use 'folke/lsp-colors.nvim' -- fix colorschemes that don't support lsp highlights

  -- ui
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons'}}

  -- formatting/syntax
  use 'NoahTheDuke/vim-just'
  use 'dense-analysis/ale'
  --use 'IndianBoy42/tree-sitter-just' -- disabled in favour of manual install, see plugin-configs/tree-sitter-just

  -- Development
  use 'neovim/nvim-lspconfig'
  use 'mfussenegger/nvim-jdtls'
  use {
    'mfussenegger/nvim-dap', requires = {
      'theHamsta/nvim-dap-virtual-text',
      'rcarriga/nvim-dap-ui'
    }
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim'}
  }
  use 'mfussenegger/nvim-fzy' -- TODO this or Telescope?
  -- lspsaga incompatible with nightly - https://github.com/glepnir/lspsaga.nvim/issues/241
  -- use 'glepnir/lspsaga.nvim'
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
  use { 'nvim-treesitter/nvim-treesitter', branch = '0.5-compat', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim", -- add pictograms to lsp suggestions
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip", -- cmp/luasnip bridge
      "rafamadriz/friendly-snippets", -- snippets for luasnip
    }
  }
--  use {'ray-x/navigator.lua', requires = {'ray-x/guihua.lua', run = 'cd lua/fzy && make'}}
  use { "ray-x/lsp_signature.nvim" }
  --use { "ThePrimeagen/harpoon", requires = {'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim'} }
  use 'liuchengxu/vista.vim' -- symbol navigation
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    -- tag = 'release' -- To use the latest release
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
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-unimpaired'
end)
