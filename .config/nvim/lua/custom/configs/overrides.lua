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

	on_attach = function(bufnr)
		local api = require("nvim-tree.api")

		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end

		local mappings = {
			["<C-e>"] = { api.node.open.replace_tree_buffer, "Open: In Place" },
			["<C-k>"] = { api.node.show_info_popup, "Info" },
			["<C-r>"] = { api.fs.rename_sub, "Rename: Omit Filename" },
			["<C-t>"] = { api.node.open.tab, "Open: New Tab" },
			["<C-v>"] = { api.node.open.vertical, "Open: Vertical Split" },
			["<C-x>"] = { api.node.open.horizontal, "Open: Horizontal Split" },
			["<BS>"] = { api.node.navigate.parent_close, "Close Directory" },
			["<CR>"] = { api.node.open.edit, "Open" },
			[">"] = { api.node.navigate.sibling.next, "Next Sibling" },
			["<"] = { api.node.navigate.sibling.prev, "Previous Sibling" },
			["."] = { api.node.run.cmd, "Run Command" },
			["-"] = { api.tree.change_root_to_parent, "Up" },
			["a"] = { api.fs.create, "Create" },
			["B"] = { api.tree.toggle_no_buffer_filter, "Toggle No Buffer" },
			["c"] = { api.fs.copy.node, "Copy" },
			["d"] = { api.fs.remove, "Delete" },
			["E"] = { api.tree.expand_all, "Expand All" },
			["e"] = { api.fs.rename_basename, "Rename: Basename" },
			["F"] = { api.live_filter.clear, "Clean Filter" },
			["f"] = { api.live_filter.start, "Filter" },
			["g?"] = { api.tree.toggle_help, "Help" },
			["gy"] = { api.fs.copy.absolute_path, "Copy Absolute Path" },
			["H"] = { api.tree.toggle_hidden_filter, "Toggle Dotfiles" },
			["I"] = { api.tree.toggle_gitignore_filter, "Toggle Git Ignore" },
			["J"] = { api.node.navigate.sibling.last, "Last Sibling" },
			["K"] = { api.node.navigate.sibling.first, "First Sibling" },
			["m"] = { api.marks.toggle, "Toggle Bookmark" },
			["o"] = { api.node.open.edit, "Open" },
			["O"] = { api.node.open.no_window_picker, "Open: No Window Picker" },
			["p"] = { api.fs.paste, "Paste" },
			["P"] = { api.node.navigate.parent, "Parent Directory" },
			["q"] = { api.tree.close, "Close" },
			["r"] = { api.fs.rename, "Rename" },
			["R"] = { api.tree.reload, "Refresh" },
			["U"] = { api.tree.toggle_custom_filter, "Toggle Hidden" },
			["W"] = { api.tree.collapse_all, "Collapse" },
			["x"] = { api.fs.cut, "Cut" },
			["y"] = { api.fs.copy.filename, "Copy Name" },
			["Y"] = { api.fs.copy.relative_path, "Copy Relative Path" },
			["<2-LeftMouse>"] = { api.node.open.edit, "Open" },
			["h"] = { api.node.navigate.parent_close, "Close Directory" },
			["v"] = { api.node.open.vertical, "Open: Vertical Split" },
			["C"] = { api.tree.change_root_to_node, "CD" },
		}

		for keys, mapping in pairs(mappings) do
			vim.keymap.set("n", keys, mapping[1], opts(mapping[2]))
		end
	end,

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
