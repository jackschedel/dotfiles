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

M.treesitter = {
	ensure_installed = {
		"vim",
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
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"prettier",

		-- c/cpp stuff
		"clangd",
		"clang-format",

		-- extra langs
		"rust-analyzer",
		"omnisharp",
		"gopls",
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

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

return M
