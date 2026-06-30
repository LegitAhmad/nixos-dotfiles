return {
	"jjsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	after = function()
		require("jjsigns").setup({})
	end,
}
