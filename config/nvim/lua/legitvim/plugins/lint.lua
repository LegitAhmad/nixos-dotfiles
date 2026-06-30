-- nvim-lint: code linting
local ok, lint = pcall(require, "lint")
if not ok then return end

lint.linters_by_ft = {
  python = { "ruff" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  go = { "golangcilint" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
