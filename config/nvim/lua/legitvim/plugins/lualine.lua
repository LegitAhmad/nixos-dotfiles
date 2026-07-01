return {
	"lualine.nvim",
	event = "DeferredUIEnter",
	after = function()
		require("lualine").setup({
			sections = {
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					"diff",
				},
			},
		})
	end,
}
