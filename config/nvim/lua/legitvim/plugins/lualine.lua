-- Setup statusline (lualine)
local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
  lualine.setup()
end