return {
	"flash.nvim",
	event = "DeferredUIEnter",
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash Jump",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
	},
	after = function()
		require("flash").setup({
			modes = {
				char = {
					enabled = true,
					jump_labels = true,
				},
			},
		})
	end,
}
