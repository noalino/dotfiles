local success_configs, configs = pcall(require, "nvim-treesitter.configs")
if not success_configs then
	return
end

configs.setup({
	ensure_installed = "all", -- "all" or a list of languages
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "" }, -- list of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of languages that will be disabled
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = { "python", "yaml" }, -- Waiting for a fix
	},
})
