return {
	"blink.cmp",
	event = "InsertEnter",
	after = function()
		require("blink.cmp").setup({
			keymap = {
				preset = "default",
				["<Tab>"] = { "accept", "fallback" },
				["<CR>"] = { "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			enabled = function()
				-- Disable in prompts, terminals, and visual/special buffers
				if vim.bo.buftype == "prompt" or vim.bo.buftype == "terminal" or vim.bo.buftype == "nofile" then
					return false
				end

				if vim.bo.filetype == "snacks_picker_input" or vim.bo.filetype == "TelescopePrompt" or vim.bo.filetype == "minifiles" then
          return false
        end

				-- Disable if the current buffer is a command-line window (e.g., q:)
				if vim.fn.getcmdwintype() ~= "" then
					return false
				end

				return true
			end,
		})
	end,
}
