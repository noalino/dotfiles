local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local success, packer = pcall(require, "packer")
if not success then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("numToStr/Comment.nvim") -- Easily comment stuff
	use("windwp/nvim-autopairs") -- Autopairs
	-- use({ -- TODO: not working! And issue when tabbing in insert mode with ";" character on SQL files
	-- 	"abecodes/tabout.nvim", -- Easy go out of autopairs
	-- 	requires = { "nvim-treesitter/nvim-treesitter" },
	-- 	after = { "nvim-cmp" },
	-- })
	use("lukas-reineke/indent-blankline.nvim") -- Indentation guidelines
	use({
		"akinsho/bufferline.nvim", -- Bufferline
		tag = "v3.0.0",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})
	use("lewis6991/gitsigns.nvim")

	-- Colorscheme
	-- use("morhetz/gruvbox") -- gruvbox theme
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("nvim-lualine/lualine.nvim") -- status bar theme

	-- NvimTree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
	})

	-- Completion
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp") -- LSP completions

	-- Snippets
	use("L3MON4D3/LuaSnip") -- Snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})
	use("jose-elias-alvarez/null-ls.nvim")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- Native fzf for better perfs

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
