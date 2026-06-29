_G.START_TIME = (vim.uv or vim.loop).hrtime()

require('legitvim.options')
require('legitvim.keymaps')
require('legitvim.lsp')

-- Automatically require all Lua files under lua/legitvim/plugins/
local plugin_configs = vim.api.nvim_get_runtime_file("lua/legitvim/plugins/*.lua", true)
for _, filepath in ipairs(plugin_configs) do
  local filename = vim.fs.basename(filepath)
  local module_name = filename:sub(1, -5) -- Strip ".lua" extension
  -- Prevent requiring an init.lua in the plugins folder if one exists
  if module_name ~= "init" then
    require("legitvim.plugins." .. module_name)
  end
end

-- Pressing <leader>cl will print out what's attached to your current buffer
vim.keymap.set("n", "<leader>cl", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.WARN)
    return
  end
  for _, client in ipairs(clients) do
    vim.notify("Active LSP: " .. client.name, vim.log.levels.INFO)
  end
end, { desc = "Check Active LSP Clients" })

print("Hello from your custom MNW Lua configuration!")
