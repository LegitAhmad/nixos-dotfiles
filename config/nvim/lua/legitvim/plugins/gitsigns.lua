return {
	"gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	after = function()
		require("gitsigns").setup()
	end,
}
