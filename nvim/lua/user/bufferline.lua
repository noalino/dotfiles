local success, bufferline = pcall(require, "bufferline")
if not success then
	return
end

bufferline.setup({
	options = {
		diagnostics = false,
		offsets = {
			{ filetype = "NvimTree", text = "File Explorer", padding = 1 },
		},
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "slant",
	},
})
