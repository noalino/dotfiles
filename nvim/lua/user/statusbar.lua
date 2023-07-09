local ok, lualine = pcall(require, "lualine")

if not ok then
	vim.notify("Plugin lualine not found!")
	return
end

lualine.setup({
	options = {
		disabled_filetypes = { "NvimTree" },
	},
})
