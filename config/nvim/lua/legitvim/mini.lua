-- This loads instantly because it's required in init.lua
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

local mini_loaded = false
local function load_mini_editing()
	if mini_loaded then
		return
	end
	mini_loaded = true
	pcall(function()
		require("mini.extra").setup()
		require("mini.ai").setup({
			custom_textobjects = {
				g = MiniExtra.gen_ai_spec.buffer(),
			},
		})
		require("mini.surround").setup()
		require("mini.operators").setup()
		require("mini.pairs").setup()
		require("mini.comment").setup()
		require("mini.move").setup()
		require("mini.splitjoin").setup()
	end)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	once = true,
	callback = load_mini_editing,
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
	once = true,
	callback = function()
		pcall(function()
			require("mini.completion").setup({ lsp_completion = { auto_setup = false } })
		end)
	end,
})

vim.keymap.set("n", "<leader>mf", function()
	local ok_files, mf = pcall(require, "mini.files")
	if ok_files then
		if not mf.close() then
			mf.open()
		end
	end
end, { desc = "Toggle Mini Files" })

-- Return an empty block so lz.n skips double processing
return {}
