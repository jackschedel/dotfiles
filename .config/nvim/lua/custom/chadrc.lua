---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

local function stbufnr()
	return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

M.ui = {
	theme = "gruvbox",
	theme_toggle = { "gruvbox", "gruvbox_light" },

	lsp_semantic_tokens = true,
	extended_integrations = { "dap", "bufferline" },
	hl_override = highlights.override,
	hl_add = highlights.add,

	telescope = { style = "bordered" },

	statusline = {
		theme = "vscode_colored",
		separator_style = "round",
		overriden_modules = function(modules)
			-- remove file encoding scheme in statusline (i.e. utf-8)
			modules[10] = ""

			-- relative file path rather than just file name
			modules[2] = (function()
				local icon = "󰈚 "
				local path = vim.api.nvim_buf_get_name(stbufnr())
				local relpath = vim.fn.fnamemodify(path, ":.")
				local name = (relpath == "" and "Empty ") or relpath

				if name ~= "Empty " then
					local devicons_present, devicons = pcall(require, "nvim-web-devicons")

					if devicons_present then
						local ft_icon = devicons.get_icon(name)
						icon = (ft_icon ~= nil and ft_icon) or icon
					end

					name = " " .. name .. " "
				end

				return "%#StText# " .. icon .. name
			end)()
		end,
	},

	tabufline = {
		enabled = false,
	},
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
