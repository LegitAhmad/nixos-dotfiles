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
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
	end,
}
