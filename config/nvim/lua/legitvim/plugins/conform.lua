-- Conform: code formatting
local ok, conform = pcall(require, "conform")
if not ok then return end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    nix = { "nixfmt" },
    go = { "gofmt", "goimports" },
    rust = { "rustfmt" },
    json = { "prettier" },
    yaml = { "prettier" },
    toml = { "taplo" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
