---@type ChadrcConfig
local M = {}

M.disabled = {
	n = {
		["<leader>h"] = "",
		["<leader>v"] = "",
		["<leader>n"] = "",
		["<leader>q"] = "",
		["<leader>fm"] = "",
		["<leader>cm"] = "",
		["<leader>rn"] = "",
		["<leader>e"] = "",
		["<C-n>"] = "",
		["<leader>ma"] = "",
	},
}

M.general = {
	v = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<Tab>"] = { ">llgv", "Indent line" },
		["<S-Tab>"] = { "<hhgv", "De-indent line" },
	},
	i = {
		["<Up>"] = {
			function()
				if require("cmp").visible() then
					require("cmp").select_prev_item()
				else
					local cur = vim.api.nvim_win_get_cursor(0)
					vim.api.nvim_win_set_cursor(0, { cur[1] - 1, cur[2] })
				end
			end,
			"Previous suggestion",
		},
		["<Down>"] = {
			function()
				if require("cmp").visible() then
					require("cmp").select_next_item()
				else
					local cur = vim.api.nvim_win_get_cursor(0)
					vim.api.nvim_win_set_cursor(0, { cur[1] + 1, cur[2] })
				end
			end,
			"Next suggestion",
		},
	},
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<Tab>"] = { "V>ll", "Indent line" },
		["<leader><CR>"] = {
			function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
			end,
			"Add spacing below",
		},
		["<S-Tab>"] = { "V<hh", "De-indent line" },
		["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "Find files in Git repo" },
		["<leader>le"] = {
			function()
				vim.diagnostic.open_float({ border = "rounded" })
			end,
			"Floating diagnostic",
		},
		["<leader>ta"] = {
			function()
				vim.opt.tabstop = 2
				vim.opt.softtabstop = 2
				vim.opt.shiftwidth = 2
				vim.opt.expandtab = true
			end,
			"Reset tab behavior",
		},
		["<leader>v"] = {
			function()
				vim.cmd("vnew")
			end,
			"Vertical Split",
		},
		["<leader>h"] = {
			function()
				vim.cmd("new")
			end,
			"Horizontal Split",
		},
		["<leader>V"] = {
			function()
				vim.cmd("vsplit #")
			end,
			-- Vertical Split (Clone)
			"which_key_ignore",
		},
		["<leader>H"] = {
			function()
				vim.cmd("split #")
			end,
			-- Horizontal Split (Clone)
			"which_key_ignore",
		},
		["<leader>tv"] = {
			function()
				require("nvterm.terminal").new("vertical")
			end,
			"Vertical Terminal Split",
		},
		["<leader>th"] = {
			function()
				require("nvterm.terminal").new("horizontal")
			end,
			"Horizontal Terminal Split",
		},
		["<leader>lf"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"LSP formatting",
		},
		["<leader>lAl"] = {
			function() local cmd = vim.api.nvim_command
				local files = vim.fn.glob(vim.fn.getcwd() .. "/*.lua", false, true)
				for _, file in ipairs(files) do
					cmd("edit " .. file)
					vim.lsp.buf.format()
					cmd("wq")
				end
			end,
			"Format all .lua files",
		},
		["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
		["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle Explorer" },
		["<leader>tm"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
		["<leader>tp"] = { "<cmd> Telescope themes <CR>", "Theme Picker" },
		["<F5>"] = {
			function()
				vim.cmd("!./nvim-run.sh")
			end,
			"Build and Run",
		},
		["<leader>tn"] = { "<cmd> set nu! <CR>", "Toggle line number" },
	},
}

M.harpoon = {
	n = {
		["<leader>a"] = {
			function()
				require("harpoon.mark").add_file()
			end,
			"Harpoon Add",
		},
		["<leader>q"] = {
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			"Harpoon Quickmenu",
		},
		["<leader>1"] = {
			function()
				require("harpoon.ui").nav_file(1)
			end,
			-- Harpoon #1
			"which_key_ignore",
		},
		["<leader>2"] = {
			function()
				require("harpoon.ui").nav_file(2)
			end,
			-- Harpoon #2
			"which_key_ignore",
		},
		["<leader>3"] = {
			function()
				require("harpoon.ui").nav_file(3)
			end,
			-- Harpoon #3
			"which_key_ignore",
		},
		["<leader>4"] = {
			function()
				require("harpoon.ui").nav_file(4)
			end,
			-- Harpoon #4
			"which_key_ignore",
		},
		["<leader>5"] = {
			function()
				require("harpoon.ui").nav_file(5)
			end,
			-- Harpoon #5
			"which_key_ignore",
		},
	},
}

-- more keybinds!

return M
