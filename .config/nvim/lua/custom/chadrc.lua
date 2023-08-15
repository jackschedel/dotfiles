---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "gruvbox",
	theme_toggle = { "gruvbox", "gruvbox_light" },

	lsp_semantic_tokens = true,
	extended_integrations = { "dap", "bufferline" },
	hl_override = highlights.override,
	hl_add = highlights.add,

	telescope = { style = "borderless" },

	statusline = {
		theme = "vscode_colored",
		separator_style = "round",
		overriden_modules = nil,
	},

	tabufline = {
		enabled = false,
	},
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
