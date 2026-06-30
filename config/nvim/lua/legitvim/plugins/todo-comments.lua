return {
	"todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	after = function()
		local todo = require("todo-comments")
		todo.setup()

		vim.keymap.set("n", "]t", function()
			todo.jump_next()
		end, { desc = "Next Todo Comment" })
		vim.keymap.set("n", "[t", function()
			todo.jump_prev()
		end, { desc = "Previous Todo Comment" })
	end,
}
