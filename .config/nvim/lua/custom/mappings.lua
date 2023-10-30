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

		-- ["<leader>gc"] = {
		-- 	function()
		--
		-- 	end,
		-- 	"Worktree create",
		-- },
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
		["<leader>u"] = {
			function()
				vim.cmd("UndotreeToggle")
			end,
			"Undotree",
		},
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
		["<leader>fw"] = {
			function()
				vim.cmd("Telescope live_grep")
			end,
			"Grep normal files",
		},
		["<leader>fl"] = {
			function()
				local success, _ = pcall(function()
					vim.cmd("Telescope git_grep live_grep")
				end)

				if not success then
					vim.cmd("Telescope live_grep")
				end
			end,
			"Grep in Git repo",
		},
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
		["<leader>lL"] = {
			function()
				local error_exists = vim.diagnostic.open_float({ border = "rounded" })
				if error_exists then
					vim.diagnostic.open_float({ border = "rounded" })
					vim.api.nvim_command("normal jyG")
					vim.cmd("q")
				end
			end,
			"Copy all diagnostics",
		},
		["<leader>ll"] = {
			function()
				local error_exists = vim.diagnostic.open_float({ border = "rounded" })
				if error_exists then
					vim.diagnostic.open_float({ border = "rounded" })
					vim.api.nvim_command("normal jllly$")
					vim.cmd("q")
				end
			end,
			"Copy diagnostic",
		},
		["<leader>P"] = {
			function()
				vim.api.nvim_command("normal ggVGP")
			end,
			"Paste replace current buffer",
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
		["<leader>lS"] = {
			function()
				vim.api.nvim_command("LspStop")
			end,
			"Stop LSP",
		},
		["<leader>lf"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"LSP formatting",
		},
		["<leader>lAF"] = {
			function()
				local buffers = vim.fn.getbufinfo()
				for _, buf in ipairs(buffers) do
					vim.fn.bufload(buf.bufnr)
					vim.api.nvim_set_current_buf(buf.bufnr)
					vim.lsp.buf.format({
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
					vim.api.nvim_command("write")
					vim.api.nvim_command("bdelete")
				end
			end,
			"LSP format all buffers",
		},
		["<leader>lAo"] = {
			function()
				local exts = {
					"ts",
					"tsx",
					"js",
					"jsx",
					"html",
					"css",
					"md",
					"yaml",
					"scss",
					"json",
					"yml",
					"lua",
					"c",
					"py",
					"cpp",
					"asm",
				}
				for _, ext in ipairs(exts) do
					local files = vim.fn.glob("**/*." .. ext)
					if #files > 0 then
						vim.cmd("args **/*." .. ext)
					end
				end
			end,
			"Open all src files",
		},
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

-- more keybinds!

return M
