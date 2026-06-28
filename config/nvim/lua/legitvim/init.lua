-- Basic Neovim Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8

-- Set mapleader to space
vim.g.mapleader = " "

-- Setup catppuccin colorscheme
local theme_ok, theme = pcall(require, "gruvbox")
if theme_ok then
  -- theme.setup({
  --   -- flavour = "mocha", -- latte, frappe, macchiato, mocha
  -- })
  vim.cmd.colorscheme("gruvbox")
else
  vim.cmd.colorscheme("habamax")
end

-- Setup statusline (lualine)
local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
  lualine.setup()
end

-- Setup gitsigns
local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if gitsigns_ok then
  gitsigns.setup()
end

-- Keymaps
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Project View" })

-- Setup basic LSP config if lspconfig is available
vim.lsp.enable("nixd")

print("Hello from your custom MNW Lua configuration!")
