-- Todo Comments: highlight and navigate TODO/FIXME/HACK etc.
local ok, todo_comments = pcall(require, "todo-comments")
if not ok then return end

todo_comments.setup()

vim.keymap.set("n", "]t", function() todo_comments.jump_next() end, { desc = "Next Todo Comment" })
vim.keymap.set("n", "[t", function() todo_comments.jump_prev() end, { desc = "Previous Todo Comment" })
