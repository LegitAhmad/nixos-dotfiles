local ok, snacks = pcall(require, "snacks")
if not ok then return end

snacks.setup({
  animate = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      function()
        local stats = ""
        if _G.START_TIME then
          local ms = ((vim.uv or vim.loop).hrtime() - _G.START_TIME) / 1e6
          stats = string.format("⚡ Neovim loaded in %.2fms", ms)
        end
        return {
          align = "center",
          text = {
            { stats, hl = "SnacksDashboardKey" },
          },
        }
      end,
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
  explorer = { enabled = true },
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
    timeout = 3000
  },
  picker = { enabled = true, ui_select = true },
  quickfile = { enabled = true },
  scratch = { enabled = true },
  scroll = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = { enabled = true },
  words = { enabled = true },
})

-- Keymaps
-- Git blame line
vim.keymap.set("n", "<leader>gb", function() snacks.git.blame_line() end, { desc = "Git Blame Line" })
-- Git browse (open in browser)
vim.keymap.set("n", "<leader>go", function() snacks.gitbrowse() end, { desc = "Git Browse Repository" })
-- Toggle lazygit
vim.keymap.set("n", "<leader>gg", function() snacks.lazygit() end, { desc = "Toggle Lazygit" })
-- Toggle file explorer
vim.keymap.set("n", "<leader>e", function() snacks.explorer() end, { desc = "Toggle File Explorer" })
-- Toggle scratch buffer
vim.keymap.set("n", "<leader>sb", function() snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
-- Toggle terminal
vim.keymap.set("n", "<leader>tt", function() snacks.terminal() end, { desc = "Toggle Terminal" })

-- Picker Keymaps
-- Find files
vim.keymap.set("n", "<leader>ff", function() snacks.picker.files() end, { desc = "Find Files" })
-- Search grep
vim.keymap.set("n", "<leader>sg", function() snacks.picker.grep() end, { desc = "Search Grep" })
-- Recent files
vim.keymap.set("n", "<leader>fr", function() snacks.picker.recent() end, { desc = "Recent Files" })
-- Buffers list
vim.keymap.set("n", "<leader>fb", function() snacks.picker.buffers() end, { desc = "Buffers" })
-- Undo history
vim.keymap.set("n", "<leader>su", function() snacks.picker.undo() end, { desc = "Search Undo History" })
-- Open all pickers list
vim.keymap.set("n", "<leader>sp", function() snacks.picker() end, { desc = "Search Pickers" })

-- Explicitly override Neovim's built-in UI input/select to guarantee Snacks handles them immediately
vim.ui.input = snacks.input.input
vim.ui.select = snacks.picker.select

-- Toggle Keymaps
snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
snacks.toggle.diagnostics():map("<leader>ud")
snacks.toggle.line_number():map("<leader>ul")
snacks.toggle.treesitter():map("<leader>uT")

