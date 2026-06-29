local ok, noice = pcall(require, "noice")
if not ok then return end

noice.setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup", -- Centers the cmdline in a floating window
  },
  messages = {
    enabled = true,
  },
  popupmenu = {
    enabled = true, -- Enable fancy popupmenu for completions/commands
  },
  notify = {
    enabled = false, -- Disabled to let snacks.notifier handle notifications
  },
  lsp = {
    -- Override markdown rendering so hover docs and signature help look beautiful
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true, -- Use a classic bottom search bar for / searches
    command_palette = true, -- Position the cmdline and popupmenu together in the center
    long_message_to_split = true, -- Long messages will be sent to a split
    inc_rename = false,
    lsp_doc_border = true, -- Add a border to hover docs and signature help
  },
})
