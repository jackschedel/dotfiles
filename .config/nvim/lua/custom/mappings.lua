---@type ChadrcConfig
local M = {}

function VFit()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local max_width = 0
	for _, line in ipairs(lines) do
		local width = vim.fn.strdisplaywidth(line)
		if width > max_width then
			max_width = width
		end
	end
	vim.cmd("vertical resize " .. max_width + 6)
end

function HFit()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local max_height = #lines
	vim.cmd("resize " .. max_height + 1)
end

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
		["A-v"] = "",
	},
}

M.NvChad = {
	n = {
		["<leader>Ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
		["<leader>Ct"] = { "<cmd> Telescope themes <CR>", "Theme picker" },
		["<leader>Cr"] = { "<cmd> source ~/.Session.vim <CR>", "Restore Session" },
		["<leader>Cf"] = { "<cmd> Telescope help_tags <CR>", "Search help" },
	},
}

M.Git = {
	n = {
		["<leader>ga"] = {
			function()
				pcall(function()
					vim.cmd("w")
				end)
				vim.cmd("silent ! git add -A")
			end,
			"Stage all",
		},
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
		["<leader>gg"] = {
			function()
				pcall(function()
					vim.cmd("w")
				end)
				vim.cmd("LazyGit")
			end,
			"LazyGit",
		},
	},
}

M.LSP = {
	n = {
		["<leader>la"] = {
			function()
				local current_ft = vim.bo.filetype
				if current_ft == "rust" then
					vim.cmd.RustLsp("codeAction")
				else
					vim.lsp.buf.code_action()
				end
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
					vim.cmd("normal jllly$")
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
					vim.cmd("normal jyG")
					vim.cmd("q")
				end
			end,
			"Copy all diagnostics",
		},
		["<leader>lf"] = {
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			"Format",
		},
	},
}

M.general = {
	v = {
		[";"] = { ":", "which_key_ignore", opts = { nowait = true } },
		[":"] = { ";", "which_key_ignore", opts = { nowait = true } },
		["x"] = { '"_d', "which_key_ignore" },
		["<leader>d"] = { '"_d', "which_key_ignore" },
		["c"] = { '"_c', "which_key_ignore" },
		["<Tab>"] = { ">llgv", "Indent line" },
		["<S-Tab>"] = { "<hhgv", "De-indent line" },
		["<leader>o"] = {
			function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
				vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
			end,
			"Add spacing around",
		},
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
		-- x and c don't replace register
		["x"] = { '"_x', "which_key_ignore" },
		["X"] = { '"_X', "which_key_ignore" },
		["c"] = { '"_c', "which_key_ignore", opts = { nowait = true } },
		["cc"] = { '"_cc', "which_key_ignore", opts = { nowait = true } },
		["ci"] = { '"_ci', "which_key_ignore", opts = { nowait = true } },
		["ct"] = { '"_ct', "which_key_ignore", opts = { nowait = true } },
		["cf"] = { '"_cf', "which_key_ignore", opts = { nowait = true } },
		["ca"] = { '"_ca', "which_key_ignore", opts = { nowait = true } },
		["C"] = { '"_C', "which_key_ignore" },
		["<leader d>"] = { '"_d', "which_key_ignore", opts = { nowait = true } },
		["{"] = { "?{<CR>", "which_key_ignore", opts = { nowait = true } },
		["}"] = { "/}<CR>", "which_key_ignore", opts = { nowait = true } },
		[";"] = { ":", "which_key_ignore", opts = { nowait = true } },
		[":"] = { ";", "which_key_ignore", opts = { nowait = true } },
		["<leader>{"] = { "f{va{o0", "Select {} Block" },
		["gt"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			"LSP type definition",
		},
		["I"] = {
			function()
				vim.cmd("normal _")
				vim.cmd("startinsert")
			end,
			"which_key_ignore",
		},
		["<C-h>"] = { "<Cmd>NavigatorLeft<CR>", "which_key_ignore" },
		["<C-j>"] = { "<Cmd>NavigatorDown<CR>", "which_key_ignore" },
		["<C-k>"] = { "<Cmd>NavigatorUp<CR>", "which_key_ignore" },
		["<C-l>"] = { "<Cmd>NavigatorRight<CR>", "which_key_ignore" },
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
		["<S-Left>"] = { "2<C-W><", "which_key_ignore" },
		["<S-Up>"] = { "2<C-W>+", "which_key_ignore" },
		["<S-Down>"] = { "2<C-W>-", "which_key_ignore" },
		["<S-Right>"] = { "2<C-W>>", "which_key_ignore" },
		["<C-W>v"] = {
			function()
				VFit()
			end,
			"Vertical scale to fit",
		},
		["<C-W>h"] = {
			function()
				HFit()
			end,
			"Horizontal scale to fit",
		},
		["<leader>o"] = {
			function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
				vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
			end,
			"Add spacing around",
		},
		["<leader>m"] = { "<cmd> Telescope marks <CR>", "Marks" },
		["<leader>N"] = { "<cmd> enew <CR>", "New buffer" },
		["<leader>p"] = {
			function()
				vim.cmd("normal o")
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
				vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
				vim.cmd("normal p")
				require("conform").format({ async = true, lsp_fallback = true })
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
				vim.cmd("normal ggVGP")
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
		["<F4>"] = {
			function()
				vim.cmd("silent ! explorer.exe .")
			end,
			"Open Explorer Here",
		},
		["<F5>"] = {
			function()
				pcall(function()
					vim.cmd("w")
				end)
				local current_ft = vim.bo.filetype
				if current_ft == "rust" then
					vim.cmd.RustLsp({
						"runnables",
						"last" --[[ optional ]],
					})
				else
					vim.cmd("!./.nvim-run.sh")
				end
			end,
			"Run Script",
		},
		["<F6>"] = {
			function()
				local tabs = vim.api.nvim_list_tabpages()
				for _, tab in ipairs(tabs) do
					local windows = vim.api.nvim_tabpage_list_wins(tab)
					for _, win in ipairs(windows) do
						local buf = vim.api.nvim_win_get_buf(win)
						vim.fn.bufload(buf)
						vim.api.nvim_set_current_win(win)
						local success = false
						success, _ = pcall(function()
							vim.cmd("w")
							local current_ft = vim.bo.filetype
							if current_ft == "rust" then
								vim.cmd.RustLsp({
									"debuggables",
									"last" --[[ optional ]],
								})
							else
								require("dap").continue()
							end
						end)
						if success then
							return
						end
					end
				end
			end,
			"Debug",
		},
		["<F7>"] = {
			function()
				require("dap").step_over()
			end,
			"Step Over",
			opts = { silent = true },
		},
	},
}

M.DAP = {
	plugin = true,
	n = {
		["<leader>Dc"] = {
			function()
				require("dap").continue()
			end,
			"Continue",
			opts = { silent = true },
		},
		["<leader>Do"] = {
			function()
				require("dap").step_over()
			end,
			"Step Over",
			opts = { silent = true },
		},
		["<leader>Di"] = {
			function()
				require("dap").step_into()
			end,
			"Step Into",
			opts = { silent = true },
		},
		["<leader>Du"] = {
			function()
				require("dap").step_out()
			end,
			"Step Out",
			opts = { silent = true },
		},
		["<leader>Db"] = {
			function()
				require("dap").toggle_breakpoint()
			end,
			"Breakpoint",
			opts = { silent = true },
		},
		["<leader>DB"] = {
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			"Breakpoint Condition",
			opts = { silent = true },
		},
		["<leader>DD"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Dap UI", opts = { silent = true } },
		["<leader>Dl"] = { "<cmd>lua require'dap'.run_last()<cr>", "Run Last", opts = { silent = true } },
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
		["<leader>!"] = {
			function()
				vim.cmd("vnew")
				require("harpoon.ui").nav_file(1)
				VFit()
			end,
			"which_key_ignore",
		},
		["<leader>2"] = {
			function()
				require("harpoon.ui").nav_file(2)
			end,
			-- Harpoon #2
			"which_key_ignore",
		},
		["<leader>@"] = {
			function()
				vim.cmd("vnew")
				require("harpoon.ui").nav_file(2)
				VFit()
			end,
			"which_key_ignore",
		},
		["<leader>3"] = {
			function()
				require("harpoon.ui").nav_file(3)
			end,
			-- Harpoon #3
			"which_key_ignore",
		},
		["<leader>#"] = {
			function()
				vim.cmd("vnew")
				require("harpoon.ui").nav_file(3)
				VFit()
			end,
			"which_key_ignore",
		},
		["<leader>4"] = {
			function()
				require("harpoon.ui").nav_file(4)
			end,
			-- Harpoon #4
			"which_key_ignore",
		},
		["<leader>$"] = {
			function()
				vim.cmd("vnew")
				require("harpoon.ui").nav_file(4)
				VFit()
			end,
			"which_key_ignore",
		},
		["<leader>5"] = {
			function()
				require("harpoon.ui").nav_file(5)
			end,
			-- Harpoon #5
			"which_key_ignore",
		},
		["<leader>%"] = {
			function()
				vim.cmd("vnew")
				require("harpoon.ui").nav_file(5)
				VFit()
			end,
			"which_key_ignore",
		},
		["<leader>6"] = {
			function()
				require("harpoon.ui").nav_file(6)
			end,
			-- Harpoon #6
			"which_key_ignore",
		},
		["<leader>^"] = {
			function()
				vim.cmd("vnew")
				require("harpoon.ui").nav_file(6)
				VFit()
			end,
			"which_key_ignore",
		},
	},
}

return M
