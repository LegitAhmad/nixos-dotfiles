-- Safely load the colorscheme plugin
local status_ok, theme = pcall(require, "catppuccin")
if not status_ok then
	return
end

-- Configure the theme options
theme.setup({
	flavour = "macchiato",
})

-- Load the specific variant
vim.cmd("colorscheme catppuccin")
