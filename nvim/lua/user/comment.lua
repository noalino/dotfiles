local ok, comment = pcall(require, "Comment")
if not ok then
  vim.notify("Module comment not found!")
	return
end

comment.setup()
