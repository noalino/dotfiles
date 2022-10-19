local success, null_ls = pcall(require, "null-ls")
if not success then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Should have binaries installed on the machine
null_ls.setup({
	sources = {
		diagnostics.eslint,
		formatting.prettier,
		formatting.stylua,
	},
})
