---@type ChadrcConfig
local M = {}

M.disabled = {
	v = {
		["<leader>ca"] = "",
	},
	n = {
		["<leader>h"] = "",
		["<leader>v"] = "",
		["<leader>n"] = "",
		["<leader>ca"] = "",
		["<leader>q"] = "",
		["<leader>fm"] = "",
		["<leader>cm"] = "",
		["<leader>rn"] = "",
		["<leader>e"] = "",
		["<leader>ra"] = "",
		["<C-n>"] = "",
		["gt"] = "",
		["gT"] = "",
		["<leader>D"] = "",
		["<leader>ma"] = "",
		["<leader>rh"] = "",
		["<leader>cc"] = "",
		["<leader>ph"] = "",
		["<leader>gt"] = "",
		["<leader>gb"] = "",
		["<leader>pt"] = "",
		["<leader>b"] = "",
		["<leader>ch"] = "",
		["<leader>th"] = "",
		["<leader>td"] = "",
		["<leader>wk"] = "",
		["<leader>wK"] = "",
		["<leader>wa"] = "",
		["<leader>wl"] = "",
		["<leader>wr"] = "",
	},
}

M.NvChad = {
	n = {
		["<leader>Ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
		["<leader>Ct"] = { "<cmd> Telescope themes <CR>", "Theme picker" },
	},
}

M.Git = {
	n = {
		["<leader>gb"] = {
			function()
				package.loaded.gitsigns.blame_line()
			end,
			"Git blame",
		},
		["<leader>gd"] = {
			function()
				require("gitsigns").toggle_deleted()
			end,
			"View deleted",
		},
	},
}

M.LSP = {
	n = {
		["<leader>la"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"Code action",
		},
		["<leader>lr"] = {
			function()
				require("nvchad.renamer").open()
			end,
			"Rename",
		},
		["<leader>le"] = {
			function()
				vim.diagnostic.open_float({ border = "rounded" })
			end,
			"Diagnostic",
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
		["<leader>lf"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"Format",
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
			"Format all buffers",
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
					"h",
					"hpp",
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
	},
}

M.general = {
	v = {
		[";"] = { ":", "which_key_ignore", opts = { nowait = true } },
		[":"] = { ";", "which_key_ignore", opts = { nowait = true } },
		["x"] = { "d", "which_key_ignore" },
		["<Tab>"] = { ">llgv", "Indent line" },
		["<S-Tab>"] = { "<hhgv", "De-indent line" },
	},
	i = {
		["<A-f>"] = {
			function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
				vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
			end,
			"Add spacing below",
		},
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
		-- x and c don't replace buffer
		["x"] = { '"_x', "which_key_ignore" },
		["c"] = { '"_c', "which_key_ignore" },
		["D"] = { '"_d', "which_key_ignore" },
		[";"] = { ":", "which_key_ignore", opts = { nowait = true } },
		[":"] = { ";", "which_key_ignore", opts = { nowait = true } },
		["<leader>N"] = { "<cmd> enew <CR>", "New buffer" },
		["gt"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			"LSP definition type",
		},
		["<leader>m"] = { "<cmd> Telescope marks <CR>", "Marks" },
		["gC"] = {
			function()
				local ok, start = require("indent_blankline.utils").get_current_context(
					vim.g.indent_blankline_context_patterns,
					vim.g.indent_blankline_use_treesitter_scope
				)

				if ok then
					vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
					vim.cmd([[normal! _]])
				end
			end,

			"Current context",
		},
		["<A-f>"] = {
			function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
				vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
			end,
			"Add spacing around",
		},
		["<leader>p"] = {
			function()
				vim.api.nvim_command("normal o")
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
				vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
				vim.api.nvim_command("normal p")
				vim.lsp.buf.format({ async = true })
			end,
			"Paste pretty",
		},
		["<leader>u"] = {
			function()
				vim.cmd("UndotreeToggle")
			end,
			"Undotree",
		},
		["<Tab>"] = { "V>ll", "Indent line" },
		["<S-Tab>"] = { "V<hh", "De-indent line" },
		["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "Find files in repo" },
		["<leader>fw"] = {
			function()
				vim.cmd("Telescope live_grep")
			end,
			"Grep files",
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
			"Grep in repo",
		},
		["<leader>P"] = {
			function()
				vim.api.nvim_command("normal ggVGP")
			end,
			"Paste buffer",
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
				vim.cmd("vsplit %")
			end,
			-- Vertical Split (Clone)
			"which_key_ignore",
		},
		["<leader>H"] = {
			function()
				vim.cmd("split %")
			end,
			-- Horizontal Split (Clone)
			"which_key_ignore",
		},
		["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle explorer" },
		["<F5>"] = {
			function()
				vim.cmd("w")
				vim.cmd("!./.nvim-run.sh")
			end,
			"Build and Run",
		},
		["<F6>"] = {
			function()
				vim.cmd("w")
				if os.execute("test -f ./.build") == 0 and os.execute("test -f ./.launch") == 0 then
					require("dap").continue()
				end
			end,
			"Debug",
		},
	},
}

M.DAP = {
	plugin = true,
	n = {
		["<leader>dc"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue", opts = { silent = true } },
		["<leader>do"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over", opts = { silent = true } },
		["<leader>di"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into", opts = { silent = true } },
		["<leader>du"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out", opts = { silent = true } },
		["<leader>db"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint", opts = { silent = true } },
		["<leader>dB"] = {
			"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
			"Breakpoint Condition",
			opts = { silent = true },
		},
		["<leader>dd"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Dap UI", opts = { silent = true } },
		["<leader>dl"] = { "<cmd>lua require'dap'.run_last()<cr>", "Run Last", opts = { silent = true } },
	},
}

M.Harpoon = {
	plugin = true,
	n = {
		["<leader>a"] = {
			function()
				require("harpoon.mark").add_file()
			end,
			-- "Harpoon add",
			"which_key_ignore",
		},
		["<leader>q"] = {
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			-- "Harpoon quickmenu",
			"which_key_ignore",
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
		["<leader>6"] = {
			function()
				require("harpoon.ui").nav_file(6)
			end,
			-- Harpoon #6
			"which_key_ignore",
		},
	},
}

return M
