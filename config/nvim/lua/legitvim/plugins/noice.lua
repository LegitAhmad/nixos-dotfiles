-- Noice: floating cmdline and enhanced messages
local ok, noice = pcall(require, "noice")
if not ok then return end

noice.setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
  },
  messages = {
    enabled = true,
  },
  popupmenu = {
    enabled = true,
  },
  notify = {
    enabled = false, -- Let snacks.notifier handle notifications
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
})
