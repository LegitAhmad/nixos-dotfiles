-- blink.cmp: fast autocompletion engine
local ok, blink = pcall(require, "blink.cmp")
if not ok then return end

blink.setup({
  keymap = { preset = "default" },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})
