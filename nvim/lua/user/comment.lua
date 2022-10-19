local success_comment, comment = pcall(require, "Comment")
if not success_comment then
	return
end

comment.setup()
