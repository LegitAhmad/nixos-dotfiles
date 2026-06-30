return {
	"sudo.nvim",
	cmd = { "SudoRead", "SudoWrite", "SudoEdit" },
	after = function()
		require("sudo").setup({})
	end,
}
