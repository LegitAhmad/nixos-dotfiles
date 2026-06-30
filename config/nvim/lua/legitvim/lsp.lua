-- Setup basic LSP config if lspconfig is available
vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", "default.nix", ".git", ".jj" },
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git", ".jj" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- TypeScript/JavaScript LSP
vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "tsconfig.json", "package.json", ".git", ".jj" },
})

-- Python LSP
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git", ".jj" },
})

-- Go LSP
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git", ".jj" },
})

-- Rust LSP
vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git", ".jj" },
})

-- Nushell LSP
vim.lsp.config("nushell", {
	cmd = { "nu", "--lsp" },
	filetypes = { "nu" },
	root_markers = { ".git", ".jj" },
})

-- Tailwind CSS LSP
vim.lsp.config("tailwindcss", {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"aspnetcorerazor",
		"astro",
		"astro-markdown",
		"blade",
		"django-html",
		"htmldjango",
		"edge",
		"eelixir",
		"elixir",
		"elm",
		"erb",
		"eruby",
		"gohtml",
		"gohtmltmpl",
		"haml",
		"handlebars",
		"hbs",
		"html",
		"htmlangular",
		"html-eex",
		"heex",
		"jade",
		"leaf",
		"liquid",
		"markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"razor",
		"slim",
		"twig",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		"javascript",
		"javascriptreact",
		"reason",
		"rescript",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"templatel",
	},
	root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json", ".git", ".jj" },
})

-- JSON LSP
vim.lsp.config("jsonls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { "package.json", ".git", ".jj" },
})

-- YAML LSP
vim.lsp.config("yamlls", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.dockerfile" },
	root_markers = { ".git", ".jj" },
})

-- TOML LSP
vim.lsp.config("taplo", {
	cmd = { "taplo", "lsp", "run" },
	filetypes = { "toml" },
	root_markers = { "Cargo.toml", ".git", ".jj" },
})

-- Markdown LSP
vim.lsp.config("marksman", {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".git", ".jj" },
})

-- Bash LSP
vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	root_markers = { ".git", ".jj" },
})

-- Enable all LSP servers automatically
vim.lsp.enable({
	"nixd",
	"lua_ls",
	"ts_ls",
	"pyright",
	"gopls",
	"rust_analyzer",
	"nushell",
	"tailwindcss",
	"jsonls",
	"yamlls",
	"taplo",
	"marksman",
	"bashls",
})
