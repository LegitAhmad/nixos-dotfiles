_G.START_TIME = (vim.uv or vim.loop).hrtime()

require("legitvim.options")
require("legitvim.keymaps")

-- immediate plugins
require("legitvim.plugins.colorscheme")
require("legitvim.plugins.mini")
require("legitvim.plugins.snacks")

-- Configure lz.n to use packadd for loading optional plugins
vim.g.lz_n = {
	load = vim.cmd.packadd,
}

-- Register all lazy-loaded plugins via lz.n
require("lz.n").load({
	-- Noice: floating cmdline and messages
	{
		"noice.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("legitvim.plugins.noice")
		end,
	},

	-- Lualine: statusline (deferred)
	{
		"lualine.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("legitvim.plugins.lualine")
		end,
	},

	-- Bufferline: tab bar (loads on first real buffer)
	{
		"bufferline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
		},
		after = function()
			require("legitvim.plugins.bufferline")
		end,
	},

	-- Gitsigns: git integration in gutter
	{
		"gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("legitvim.plugins.gitsigns")
		end,
	},

	-- Telescope: fuzzy finder
	{
		"telescope.nvim",
		cmd = "Telescope",
		after = function()
			require("telescope").setup()
		end,
	},

	-- nvim-lspconfig + LSP setup
	{
		"nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("legitvim.lsp")
		end,
	},

	-- Which-Key: keybinding helper
	{
		"which-key.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("legitvim.plugins.which-key")
		end,
	},

	-- blink.cmp: fast autocompletion
	{
		"blink.cmp",
		event = "InsertEnter",
		after = function()
			require("legitvim.plugins.blink")
		end,
	},

	-- GrugFar: search and replace
	{
		"grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{ "<leader>sr", "<cmd>GrugFar<CR>", desc = "Search & Replace (GrugFar)" },
		},
		after = function()
			require("legitvim.plugins.grug-far")
		end,
	},

	-- Trouble: diagnostics panel
	{
		"trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions/References (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo Comments (Trouble)" },
		},
		after = function()
			require("legitvim.plugins.trouble")
		end,
	},

	-- Todo Comments: highlight and navigate TODOs
	{
		"todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("legitvim.plugins.todo-comments")
		end,
	},

	-- Conform: formatting
	{
		"conform.nvim",
		event = "BufWritePre",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
				end,
				desc = "Format Document",
				mode = { "n", "v" },
			},
		},
		after = function()
			require("legitvim.plugins.conform")
		end,
	},

	-- nvim-lint: linting
	{
		"nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		after = function()
			require("legitvim.plugins.lint")
		end,
	},

	-- nvim-web-devicons: icon provider fallback
	{
		"nvim-web-devicons",
		lazy = true,
	},
})
