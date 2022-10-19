local success, npairs = pcall(require, "nvim-autopairs")
if not success then
	return
end

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = { "string" }, -- it will not add a pair on that treesitter node
		javascript = { "template_string" },
		java = false, -- don't check treesitter on java
	},
	disable_filetype = { "TelescopePrompt" },
	fast_wrap = {}, -- use default fast_wrap settings
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")

local success_cmp, cmp = pcall(require, "cmp")
if not success_cmp or not cmp then
	return
end

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
