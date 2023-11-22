local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = true
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end


return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  --use 'ellisonleao/gruvbox.nvim'
  --use 'folke/tokyonight.nvim'
  use 'navarasu/onedark.nvim'
  use 'christoomey/vim-tmux-navigator'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use {
  'phaazon/hop.nvim',
  branch = 'v2', -- optional but strongly recommended
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
  end
  }
  use {
	'nvim-lualine/lualine.nvim',
	requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  }
  use 'nvim-treesitter/nvim-treesitter'
  use {
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',
  }
  use {
	"folke/which-key.nvim",
	config = function()
	vim.o.timeout = true
	vim.o.timeoutlen = 300
	require("which-key").setup { }
  end
  }
  use {
	  'hrsh7th/nvim-cmp',
	  requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets', },
  }
  use {
	  "williamboman/mason.nvim",
	  "williamboman/mason-lspconfig.nvim",
	  "neovim/nvim-lspconfig",
  }
  use {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.3',
	requires = { {'nvim-lua/plenary.nvim'},
		{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
	        build = 'make',
	        cond = function()
	        return vim.fn.executable 'make' == 1
	        end,
		},
	},
  }
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
	print '===================='
	print ' Plugins installing'
	print '===================='
    require('packer').sync()
  end
end)
