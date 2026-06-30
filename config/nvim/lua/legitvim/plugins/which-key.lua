-- Which-Key: keybinding helper panel
local ok, wk = pcall(require, "which-key")
if not ok then return end

wk.setup({
  preset = "classic",
  delay = 500,
})
