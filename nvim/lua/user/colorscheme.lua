-- vim.cmd("colorscheme slate")

require("catppuccin").setup({
	flavour = "latte",
})
-- local colorscheme = "gruvbox"
local colorscheme = "catppuccin"

local success, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not success then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

-- vim.opt.background = "light"
-- vim.g.gruvbox_contrast_dark = "soft"
-- vim.g.gruvbox_contrast_light = "hard"
