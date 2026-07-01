local snacks = require("snacks")

snacks.setup({
	-- animate = { enabled = true },
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			(function()
				local ms = nil
				return function()
					if not ms and _G.START_TIME then
						ms = ((vim.uv or vim.loop).hrtime() - _G.START_TIME) / 1e6
					end
					local stats = ms and string.format("⚡ Neovim loaded in %.2fms", ms) or ""
					return {
						align = "center",
						text = {
							{ stats, hl = "SnacksDashboardKey" },
						},
					}
				end
			end)(),
		},
		preset = {
			header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
        ]],
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
				{ icon = " ", key = "e", desc = "File Explorer", action = ":lua Snacks.explorer()" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
	},
	bigfile = { enabled = true },
	explorer = {
		enabled = true,
		trash = true,
	},
	git = { enabled = true },
	gitbrowse = { enabled = true },
	image = { enabled = true },
	indent = { enabled = true },
	input = {
		enabled = true,
		win = {
			relative = "editor",
			position = "float",
			row = nil,
			col = nil,
			border = "rounded",
		},
	},
	lazygit = { enabled = true, configure = true },
	notifier = {
		enabled = true,
		timeout = 3000,
	},
	picker = {
		enabled = true,
		ui_select = true,
		-- Custom configuration added below to decrease explorer width
		sources = {
			explorer = {
				layout = {
					layout = {
						-- position = "left",
						width = 30, -- Adjust this value to make it narrower or wider
					},
				},
			},
		},
	},
	quickfile = { enabled = true },
	scratch = { enabled = true },
	scroll = { enabled = true },
	scope = { enabled = true },
	statuscolumn = { enabled = true },
	terminal = { enabled = true },
	words = { enabled = true },
})

-- Core UI mappings
vim.keymap.set("n", "<leader>gb", function()
	snacks.git.blame_line()
end, { desc = "Git Blame Line" })
vim.keymap.set("n", "<leader>go", function()
	snacks.gitbrowse()
end, { desc = "Git Browse Repository" })
vim.keymap.set("n", "<leader>gg", function()
	snacks.lazygit()
end, { desc = "Toggle Lazygit" })
vim.keymap.set("n", "<leader>e", function()
	snacks.explorer()
end, { desc = "Toggle File Explorer" })
vim.keymap.set("n", "<leader>sb", function()
	snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>tt", function()
	snacks.terminal()
end, { desc = "Toggle Terminal" })

-- Picker mappings
vim.keymap.set("n", "<leader><leader>", function()
	snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>/", function()
	snacks.picker.grep()
end, { desc = "Search Grep" })
vim.keymap.set("n", "<leader>fp", function()
	snacks.picker.projects()
end, { desc = "Search Projects" })
vim.keymap.set("n", "<leader>fr", function()
	snacks.picker.recent()
end, { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fb", function()
	snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>su", function()
	snacks.picker.undo()
end, { desc = "Search Undo History" })
vim.keymap.set("n", "<leader>sp", function()
	snacks.picker()
end, { desc = "Search Pickers" })

-- Guarantee selection overrides immediate load hooks
vim.ui.input = snacks.input.input
vim.ui.select = snacks.picker.select

-- Toggle settings mappings
snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
snacks.toggle.diagnostics():map("<leader>ud")
snacks.toggle.line_number():map("<leader>ul")
snacks.toggle.treesitter():map("<leader>uT")
