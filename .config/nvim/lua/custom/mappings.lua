--@type ChadrcConfig
local M = {}

function Format()
	require("conform").format({ async = true, lsp_fallback = true })
end

function JumpContext(to_top)
	local ok, start, finish = require("indent_blankline.utils").get_current_context(
		vim.g.indent_blankline_context_patterns,
		vim.g.indent_blankline_use_treesitter_scope
	)
	if ok then
		local target_line = to_top and start or finish
		vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { target_line, 0 })
	end
	if to_top then
		vim.cmd([[normal! _]])
	else
		vim.cmd([[normal! $]])
	end
end

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
		["<leader>"] = "",
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
		["<leader>lE"] = { "<cmd> Telescope diagnostics <CR>", "Diagnostics in file" },

		["gr"] = {
			function()
				vim.cmd("Telescope lsp_references")
			end,

			"LSP references",
		},
		["gd"] = {
			function()
				local locations =
					vim.lsp.buf_request_sync(0, "textDocument/definition", vim.lsp.util.make_position_params(), 1000)
				if not locations or vim.tbl_isempty(locations) then
					return
				end

				local original_location_count = 0
				local in_node_modules = false
				for _, server_locations in pairs(locations) do
					for _, loc in ipairs(server_locations.result) do
						original_location_count = original_location_count + 1
						local uri = loc.uri or loc.targetUri
						if string.find(vim.uri_to_fname(uri), "node_modules") then
							in_node_modules = true
						else
							in_node_modules = false
						end
					end
				end

				if original_location_count == 1 and in_node_modules then
					print("Definition in node_modules")
					return
				end

				for _, server_locations in pairs(locations) do
					for i = #server_locations.result, 1, -1 do
						local uri = server_locations.result[i].uri or server_locations.result[i].targetUri
						if string.find(vim.uri_to_fname(uri), "node_modules") then
							table.remove(server_locations.result, i)
						end
					end
				end

				local filtered_locations = locations[1] and locations[1].result
				if not filtered_locations or vim.tbl_isempty(filtered_locations) then
					return
				end

				if #filtered_locations == 1 then
					vim.lsp.util.jump_to_location(filtered_locations[1], "utf-8")
					return
				end

				vim.cmd("Telescope lsp_definitions")
			end,
			"LSP definitions",
		},
		["<leader>lu"] = { "<cmd> Telescope lsp_references <CR>", "Usages" },
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
				local bufnr = vim.api.nvim_get_current_buf()
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				local cursor_line = cursor_pos[1] - 1
				local diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_line })
				if #diagnostics > 0 then
					vim.cmd("normal yy")
					local diag_text = "Diagnostics:\n"
					for _, diag in ipairs(diagnostics) do
						diag_text = diag_text .. diag.message .. "\n"
					end
					local current_line = vim.fn.getreg("*")
					vim.fn.setreg("*", current_line .. "\n" .. diag_text)
				end
			end,
			"Copy diagnostics",
		},
		["<leader>lf"] = {
			function()
				Format()
			end,
			"Format",
		},
	},
}

M.general = {
	t = {
		["<Esc>"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle floating term",
		},
	},
	v = {
		[";"] = { ":", "which_key_ignore", opts = { nowait = true } },
		[":"] = { ";", "which_key_ignore", opts = { nowait = true } },
		[","] = { "<", "which_key_ignore", opts = { nowait = true } },
		["<"] = { ",", "which_key_ignore", opts = { noremap = true } },
		["x"] = { '"_d', "which_key_ignore" },
		["<leader>d"] = { '"_d', "which_key_ignore" },
		["c"] = { '"_c', "which_key_ignore" },
		["Y"] = { "ygv", "Yank (keep selection)" },
		["<Tab>"] = { ">llgv", "Indent line" },
		["<S-Tab>"] = { "<hhgv", "De-indent line" },
		["<leader>t"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle floating term",
		},
		["<leader>o"] = {
			function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
				vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
			end,
			"Add spacing around",
		},
		["<leader>]"] = {
			function()
				vim.cmd("normal! oh")
				JumpContext(true)
				vim.cmd("normal VV")
				JumpContext(false)
			end,
			"Select Block (treesitter)",
		},
		["<leader>["] = { "okV%", "Select Matching Block" },
		["{"] = {
			function()
				vim.cmd("normal h")
				JumpContext(true)
			end,
			"Context start",
			opts = { nowait = true },
		},
		["}"] = {
			function()
				vim.cmd("normal l")
				JumpContext(false)
			end,
			"Context end",
			opts = { nowait = true },
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
		["r"] = { '"_r', "which_key_ignore" },
		["X"] = { '"_X', "which_key_ignore" },
		["c"] = { '"_c', "which_key_ignore", opts = { noremap = true } },
		["C"] = { '"_C', "which_key_ignore" },
		["<leader>d"] = { '"_d', "which_key_ignore" },
		["{"] = {
			function()
				vim.cmd("normal h")
				JumpContext(true)
			end,
			"Context start",
			opts = { nowait = true },
		},
		["}"] = {
			function()
				vim.cmd("normal l")
				JumpContext(false)
			end,
			"Context end",
			opts = { nowait = true },
		},
		[";"] = { ":", "which_key_ignore", opts = { nowait = true } },
		[":"] = { ";", "which_key_ignore", opts = { nowait = true } },
		[","] = { "<", "which_key_ignore", opts = { nowait = true } },
		["<"] = { ",", "which_key_ignore", opts = { noremap = true } },
		["<C-s>"] = { "<cmd> noautocmd w <CR>", "Save file (no autocmd)" },
		["<leader>["] = { "$V%", "Select Matching Block" },
		["<leader>]"] = {
			function()
				JumpContext(true)
				vim.cmd("normal V")
				JumpContext(false)
			end,
			"Select Block (treesitter)",
		},
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
		["<leader>t"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle floating term",
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
				Format()
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
		["<leader>fg"] = {
			function()
				local success, _ = pcall(function()
					vim.cmd("Telescope git_files")
				end)

				if not success then
					vim.cmd("Telescope find_files")
				end
			end,
			"Find repo files",
		},
		["<leader>ff"] = {
			function()
				vim.cmd("Telescope find_files")
			end,
			"Find all files",
		},
		["<leader>fa"] = {
			function()
				vim.cmd("Telescope find_files no_ignore=true hidden=true")
			end,
			"Find all files",
		},
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
				local cur_win = vim.api.nvim_get_current_win()
				local cur_pos = vim.api.nvim_win_get_cursor(cur_win)
				vim.cmd("vsplit %")
				local new_win = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_cursor(new_win, cur_pos)
			end,
			-- Vertical Split (Clone)
			"which_key_ignore",
		},
		["<leader>H"] = {
			function()
				local cur_win = vim.api.nvim_get_current_win()
				local cur_pos = vim.api.nvim_win_get_cursor(cur_win)
				vim.cmd("split %")
				local new_win = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_cursor(new_win, cur_pos)
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
				local run_script = "./.nvim-run.sh"
				if vim.fn.filereadable(run_script) == 1 then
					vim.fn.system("chmod +x " .. run_script .. " > /dev/null 2>&1")
					require("nvterm.terminal").toggle("float")
					require("nvterm.terminal").send(run_script)
					vim.cmd("startinsert")
					return
				end

				local current_ft = vim.bo.filetype
				if current_ft == "rust" then
					vim.cmd.RustLsp({
						"runnables",
						"last",
					})
				elseif current_ft == "go" then
					local current_file = vim.fn.expand("%:p")
					local relative_path = vim.fn.fnamemodify(current_file, ":.:.")
					vim.cmd("!go run " .. relative_path)
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

-- multiple register y and p binds ill actually use
for i = 0, 9 do
	local iStr = tostring(i)
	M.general.n[iStr .. "y"] = { '"' .. iStr .. "y", "which_key_ignore", opts = { noremap = true } }
	M.general.n[iStr .. "Y"] = { '"' .. iStr .. "Y", "which_key_ignore", opts = { noremap = true } }
	M.general.v[iStr .. "y"] = { '"' .. iStr .. "y", "which_key_ignore", opts = { noremap = true } }
	M.general.v[iStr .. "Y"] = { '"' .. iStr .. "ygv", "which_key_ignore", opts = { noremap = true } }

	M.general.n[iStr .. "d"] = { '"' .. iStr .. "d", "which_key_ignore", opts = { noremap = true } }
	M.general.n[iStr .. "D"] = { '"' .. iStr .. "D", "which_key_ignore", opts = { noremap = true } }
	M.general.v[iStr .. "d"] = { '"' .. iStr .. "d", "which_key_ignore", opts = { noremap = true } }

	M.general.n[iStr .. "p"] = { '"' .. iStr .. "p", "which_key_ignore", opts = { noremap = true } }
	M.general.n[iStr .. "P"] = { '"' .. iStr .. "P", "which_key_ignore", opts = { noremap = true } }
	M.general.v[iStr .. "p"] = { '"' .. iStr .. "p", "which_key_ignore", opts = { noremap = true } }
end

M.Cody = {
	n = {
		["<leader>cc"] = {
			"<Cmd>CodyChat<CR>i",
			"Cody Chat",
		},
		["<leader>cC"] = {
			"<Cmd>CodyToggle<CR>",
			"Closed Chat",
		},
		["<leader>ct"] = {
			':CodyTask ""<Left>',
			"Give Task",
		},
		["<leader>cT"] = {
			"<Cmd>CodyTaskView<CR>",
			"Closed Task",
		},
		["<leader>cA"] = {
			"<Cmd>CodyTaskAccept<CR>",
			"Accept task result",
		},
		["<leader>cN"] = {
			"<Cmd>CodyTaskNext<CR>",
			"Next Task",
		},
		["<leader>cP"] = {
			"<Cmd>CodyTaskPrev<CR>",
			"Previous Task",
		},
	},
	v = {
		["<leader>ca"] = {
			":CodyAsk ",
			"Ask Question",
		},
		["<leader>ct"] = {
			":CodyTask ",
			"Give Task",
		},
		["<leader>ce"] = {
			":CodyAsk Explain the following code:<CR>",
			"Explain Code",
		},
		["<leader>cr"] = {
			":CodyTask Rewrite the given code to be more idiomatic<CR>",
			"Idiomatic Rewrite",
		},
		["<leader>cA"] = {
			":CodyTaskAccept<CR>",
			"Accept task result",
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
