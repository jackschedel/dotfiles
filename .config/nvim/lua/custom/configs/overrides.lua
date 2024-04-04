local M = {}
local cmp = require("cmp")

require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"-u",
		},
	},
})

M.blankline = {
	indentLine_enabled = 1,
	filetype_exclude = {
		"help",
		"terminal",
		"lazy",
		"lspinfo",
		"TelescopePrompt",
		"TelescopeResults",
		"mason",
		"nvdash",
		"nvcheatsheet",
		"",
	},
	buftype_exclude = { "terminal" },
	show_trailing_blankline_indent = false,
	show_first_indent_level = true,
	show_current_context = true,
	show_current_context_start = false,
	show_current_context_start_on_current_line = false,
}

M.treesitter = {
	ensure_installed = {
		"vim",
		"vimdoc",
		"lua",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"c",
		"rust",
		"markdown",
		"markdown_inline",
		"php",
		"gdscript",
		"godot_resource",
		"c_sharp",
	},
	indent = {
		enable = true,
		disable = {
			"python",
		},
	},
}

M.mason = {
	ensure_installed = {
		"lua-language-server",
		"stylua",
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"prettierd",
		"clangd",
		"clang-format",
		"rust-analyzer",
		"omnisharp",
		"gopls",
		"intelephense",
		"jedi-language-server",
	},
}

M.cmp = {
	mapping = {
		["<Tab>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
		["<CR>"] = cmp.config.disable,
		["<S-Tab>"] = cmp.config.disable,
	},
}

M.oil = {}

return M
