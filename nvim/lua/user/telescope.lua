local ok, telescope = pcall(require, "telescope")
if not ok then
  vim.notify("Plugin telescope not found!")
	return
end

telescope.setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")
