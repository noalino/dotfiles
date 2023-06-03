local success, bufferline = pcall(require, "bufferline")
if not success then
	return
end

bufferline.setup({
	options = {
		-- TODO: Change icons
		-- indicator = {
		--   icon = "| ",
		--   style = "icon",
		-- },
		-- buffer_close_icon = '',
		-- modified_icon = '●',
		-- close_icon = '',
		-- left_trunc_marker = '',
		-- right_trunc_marker = '',
		diagnostics = false,
		offsets = {
			{ filetype = "NvimTree", text = "File Explorer", padding = 1 },
		},
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "slant",
	},
})
