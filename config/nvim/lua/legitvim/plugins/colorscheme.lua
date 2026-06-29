-- Setup colorscheme
local theme_ok, theme = pcall(require, "gruvbox")
if theme_ok then
  vim.cmd.colorscheme("gruvbox")
else
  vim.cmd.colorscheme("habamax")
end
