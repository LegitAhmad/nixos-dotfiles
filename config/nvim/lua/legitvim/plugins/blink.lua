return {
	"blink.cmp",
	event = "InsertEnter",
	after = function()
		require("blink.cmp").setup({
			keymap = { preset = "default" },
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		})
	end,
}
