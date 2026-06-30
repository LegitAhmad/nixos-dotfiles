-- mini.icons: Unified icon manager (loaded at startup for icon availability)
local ok, mini_icons = pcall(require, "mini.icons")
if ok then
  mini_icons.setup()
  mini_icons.mock_nvim_web_devicons()
end

-- The following mini modules are loaded on BufReadPost/BufNewFile via autocmd
local mini_loaded = false
local function load_mini_editing()
  if mini_loaded then return end
  mini_loaded = true
  pcall(function()
    require("mini.ai").setup()
    require("mini.surround").setup()
    require("mini.operators").setup()
    require("mini.pairs").setup()
    require("mini.comment").setup()
    require("mini.move").setup()
    require("mini.splitjoin").setup()
  end)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = load_mini_editing,
})

-- mini.completion: loads on CmdlineEnter for command-line autocomplete
vim.api.nvim_create_autocmd("CmdlineEnter", {
  once = true,
  callback = function()
    pcall(function()
      require("mini.completion").setup({ lsp_completion = { auto_setup = false } })
    end)
  end,
})

-- mini.files: loads on demand via keymap
vim.keymap.set("n", "<leader>mf", function()
  local ok_files, mf = pcall(require, "mini.files")
  if ok_files then
    if not mf.close() then mf.open() end
  end
end, { desc = "Toggle Mini Files" })
