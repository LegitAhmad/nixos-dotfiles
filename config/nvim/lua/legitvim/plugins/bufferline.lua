return {
	"bufferline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
	},
	after = function()
		local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
		local bg_hex = normal_bg and string.format("#%06x", normal_bg) or "#282828"

		require("bufferline").setup({
			options = {
				mode = "buffers",
				separator_style = "thin",
				always_show_bufferline = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
			highlights = {
				fill = {
					bg = bg_hex,
				},
			},
		})
	end,
}
