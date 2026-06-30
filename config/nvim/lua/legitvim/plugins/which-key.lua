return {
	"which-key.nvim",
	event = "DeferredUIEnter",
	after = function()
		require("which-key").setup({
			preset = "helix",
			delay = 500,
		})
	end,
}
