local success, indent_blankline = pcall(require, "indent_blankline")
if not success then
	return
end

indent_blankline.setup({
	show_end_of_line = true,
})
