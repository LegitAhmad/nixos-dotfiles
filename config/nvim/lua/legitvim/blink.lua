-- Protective autocmds — set up eagerly before any lazy loading
vim.api.nvim_create_autocmd("FileType", {
	pattern = "snacks_picker_input",
	callback = function()
		local ok, blink = pcall(require, "blink.cmp")
		if ok then
			blink.cancel()
			blink.hide()
		end
		vim.b.completion = false
	end,
})

-- Delegate actual blink.cmp setup to the lazy-loaded wrapper
require("legitvim.blink.cmp").setup({
	appearance = {
		nerd_font_variant = "mono",
	},
	keymap = {
		preset = "default",
		["<Tab>"] = { "accept", "fallback" },
		["<CR>"] = { "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
	},
	signature = {
		enabled = true,
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			snacks_picker_input = {},
			TelescopePrompt = {},
			minifiles = {},
		},
	},
	enabled = function()
		print(vim.bo.filetype, vim.bo.buftype)

		if vim.bo.buftype == "prompt" then
			print("disabled")
			return false
		end

		if vim.bo.buftype == "terminal" or vim.bo.buftype == "nofile" then
			return false
		end

		if vim.fn.getcmdwintype() ~= "" then
			return false
		end

		return true
	end,
})

-- Return an empty block so lz.n skips double processing
return {}
