_G.START_TIME = (vim.uv or vim.loop).hrtime()

require("legitvim.options")
require("legitvim.keymaps")

-- immediate plugins
require("legitvim.colorscheme")
require("legitvim.mini")
require("legitvim.snacks")

-- Configure lz.n to use packadd for loading optional plugins
vim.g.lz_n = {
	load = vim.cmd.packadd,
}

-- 🌟 Scan the plugins directory directly
require("lz.n").load("legitvim.plugins")
