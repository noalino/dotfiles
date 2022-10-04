local success, lualine = pcall(require, "lualine")

if not success then
  vim.notify("status bar could not be loaded!")
  return
end

lualine.setup()
