local function get_jj_signs()
	local status = vim.b.jj_signs_status
	if not status or status == "" then
		return ""
	end
	return status
end

return {
	"lualine.nvim",
	event = "DeferredUIEnter",
	after = function()
		-- Hook into jjsigns to update vim.b.jj_signs_status when signs change
		local ok_signs, signs_mod = pcall(require, "jjsigns.signs")
		if ok_signs then
			local original_place_signs = signs_mod.place_signs
			signs_mod.place_signs = function(bufnr, signs)
				original_place_signs(bufnr, signs)

				local added, changed, deleted = 0, 0, 0
				for _, sign in ipairs(signs or {}) do
					if sign.type == "add" then
						added = added + 1
					elseif sign.type == "change" or sign.type == "changedelete" then
						changed = changed + 1
					elseif sign.type == "delete" or sign.type == "topdelete" then
						deleted = deleted + 1
					end
				end

				local parts = {}
				if added > 0 then
					table.insert(parts, "+" .. added)
				end
				if changed > 0 then
					table.insert(parts, "~" .. changed)
				end
				if deleted > 0 then
					table.insert(parts, "-" .. deleted)
				end

				vim.b[bufnr].jj_signs_status = table.concat(parts, " ")
				vim.cmd("redrawstatus")
			end

			local original_clear_buffer = signs_mod.clear_buffer
			signs_mod.clear_buffer = function(bufnr)
				original_clear_buffer(bufnr)
				vim.b[bufnr].jj_signs_status = ""
				vim.cmd("redrawstatus")
			end
		end

		require("lualine").setup({
			sections = {
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					{
						get_jj_signs,
						icon = "   ", -- Optional icon
						color = { fg = "#00aaff" }, -- Customize colors to your liking
					},
				},
			},
		})
	end,
}
