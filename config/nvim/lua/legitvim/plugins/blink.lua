local cmp = require("legitvim.blink.cmp")

return {
	"blink.cmp",
	event = "InsertEnter",
	after = function()
		require("blink.cmp").setup(cmp.opts)
	end,
}
