-- Bufferline: tab bar
local ok, bufferline = pcall(require, "bufferline")
if not ok then return end

-- Get the editor background color from the Normal highlight group
local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
local bg_hex = normal_bg and string.format("#%06x", normal_bg) or "#282828"

bufferline.setup({
  options = {
    mode = "buffers",
    separator_style = "thin",
    always_show_bufferline = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
  highlights = {
    fill = {
      bg = bg_hex,
    },
  },
})
