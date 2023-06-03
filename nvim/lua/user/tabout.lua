local success, tabout = pcall(require, "tabout")
if not success then
	return
end

tabout.setup({
	-- tabkey = "",
	-- backwards_tabkey = "",
})
