local success, nvim_tree = pcall(require, "nvim-tree")
if not success then
	return
end

local success_config, nvim_tree_config = pcall(require, "nvim-tree.config")
if not success_config then
	return
end

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
	disable_netrw = true,
	diagnostics = {
		enable = true,
	},
	view = {
		mappings = {
			list = {
				{ key = { "l", "<CR>" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
			},
		},
	},
	filters = {
		custom = { "^\\.git" },
	},
})
