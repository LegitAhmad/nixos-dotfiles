_G.START_TIME = (vim.uv or vim.loop).hrtime()

require("legitvim.options")
require("legitvim.keymaps")

-- immediate plugins
require("legitvim.plugins.colorscheme")
require("legitvim.plugins.mini")
require("legitvim.plugins.snacks")

-- Configure lz.n to use packadd for loading optional plugins
vim.g.lz_n = {
	load = vim.cmd.packadd,
}

-- 🌟 Scan the plugins directory directly
require("lz.n").load("legitvim.plugins")
