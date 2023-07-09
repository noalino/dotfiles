local ok, indent_blankline = pcall(require, "indent-blankline")
if not ok then
  vim.notify("Plugin indent-blankline not found!")
	return
end

indent_blankline.setup({
	show_end_of_line = true,
})
