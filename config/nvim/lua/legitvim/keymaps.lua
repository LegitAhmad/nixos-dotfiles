-- Set mapleader to space
vim.g.mapleader = " "

-- 💾 Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- 🪟 Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- 🔍 Clear search highlights with ESC
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear Highlight and Escape" })

-- 📑 Better indenting (keeps visual selection)
vim.keymap.set("v", "<", "<gv", { desc = "Indent Less" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent More" })

-- 📋 System clipboard integration
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to Clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from Clipboard" })
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without overwriting register" })

-- 🗑️ Delete / Change without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]], { desc = "Change without yanking" })
vim.keymap.set({ "n", "v" }, "x", [["_x]], { desc = "Delete character without yanking" })

-- 🧭 Better search/scroll centring
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev Search Result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })

-- 🗂️ Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- 💾 Save / Quit commands
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
vim.keymap.set("n", "<leader>W", "<cmd>SudoWrite<cr>", { desc = "Save File as Root (Sudo)" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit Window" })
vim.keymap.set("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force Quit Window" })
