return {
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
		{
			"<leader>tf",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				if vim.g.disable_autoformat then
					vim.notify("Autoformat disabled globally", vim.log.levels.WARN, { title = "Conform" })
				else
					vim.notify("Autoformat enabled globally", vim.log.levels.INFO, { title = "Conform" })
				end
			end,
			desc = "Toggle Auto Format globally",
			mode = { "n" },
		},
		{
			"<leader>tF",
			function()
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				if vim.b.disable_autoformat then
					vim.notify("Autoformat disabled for buffer", vim.log.levels.WARN, { title = "Conform" })
				else
					vim.notify("Autoformat enabled for buffer", vim.log.levels.INFO, { title = "Conform" })
				end
			end,
			desc = "Toggle Auto Format for current buffer",
			mode = { "n" },
		},
	},
	after = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				nix = { "nixfmt" },
				go = { "gofmt", "goimports" },
				rust = { "rustfmt" },
				json = { "prettier" },
				yaml = { "prettier" },
				toml = { "taplo" },
				markdown = { "prettier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b.disable_autoformat then
					return
				end
				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,
		})
	end,
}
