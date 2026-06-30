return {
	"grug-far.nvim",
	cmd = "GrugFar",
	keys = {
		{ "<leader>sr", "<cmd>GrugFar<CR>", desc = "Search & Replace (GrugFar)" },
	},
	after = function()
		require("grug-far").setup()
	end,
}
