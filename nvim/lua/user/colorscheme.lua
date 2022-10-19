vim.cmd("colorscheme slate")

local colorscheme = "gruvbox"

local success, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not success then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

vim.opt.background = "light"
vim.g.gruvbox_contrast_dark = "soft"
vim.g.gruvbox_contrast_light = "hard"
