local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		config = function()
			require("core.utils").load_mappings("Harpoon")
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
		opts = {
			server = {
				on_attach = require("plugins.configs.lspconfig").on_attach,
			},
		},
		config = function(_, opts)
			vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
		end,
	},

	{ "Hoffs/omnisharp-extended-lsp.nvim", ft = { "cs" } },

	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
		event = "VeryLazy",
	},

	{
		"nvim-pack/nvim-spectre",
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "Spectre",
	},

	{
		"numToStr/Navigator.nvim",
		cmd = { "NavigatorLeft", "NavigatorDown", "NavigatorUp", "NavigatorRight" },
		config = true,
	},

	{
		"ThePrimeagen/git-worktree.nvim",
		event = "VeryLazy",
	},

	{ "mbbill/undotree", event = "VeryLazy" },

	"NvChad/nvcommunity",
	{ import = "nvcommunity.editor.hlargs" },
	{ import = "nvcommunity.editor.illuminate" },

	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			throttle = true,
			max_lines = 2,
			multiline_threshold = 1,
			trim_scope = "inner",
			mode = "topline",
		},
		-- event = "BufReadPost",
		init = function()
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					if not vim.tbl_contains({ "cs", "" }, vim.bo.ft) then
						require("treesitter-context").setup()
					end
				end,
			})
		end,
	},

	{
		"kevinhwang91/nvim-fundo",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"kevinhwang91/promise-async",
		},
		init = function()
			vim.o.undofile = true
		end,
		build = function()
			require("fundo").install()
		end,
	},

	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				yaml = { "prettierd" },
				json = { "prettierd" },
				html = { "prettierd" },
				typescriptreact = { "prettierd" },
				javascriptreact = { "prettierd" },
				jsonc = { "prettierd" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cuda = { "clang_format" },
				cs = { "clang_format" },
			},
			format_on_save = { async = true, lsp_fallback = false, quiet = true },
			formatters = { clang_format = { prepend_args = { "-style=file:/Users/jack/.config/nvim/.clang-format" } } },
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"ggandor/leap.nvim",
		event = "VeryLazy",
		dependencies = { { "tpope/vim-repeat" } },
		config = function()
			require("leap").add_default_mappings()
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		init = function()
			require("core.utils").load_mappings("DAP")
		end,
		dependencies = {
			{
				"mfussenegger/nvim-dap",
				config = function()
					-- NOTE: Check out this for guide
					-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
					local dap = require("dap")
					vim.fn.sign_define(
						"DapBreakpoint",
						{ text = "🛑", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
					)

					local dapui = require("dapui")
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end

					-- dap.listeners.before.event_terminated["dapui_config"] = function()
					--   dapui.close()
					-- end

					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end

					-- Enabled:
					-- require("custom.configs.dap.settings.cpptools")
					require("custom.configs.dap.settings.codelldb")
					require("custom.configs.dap.settings.go-debug-adapter")

					-- Disabled:
					-- require("custom.configs.dap.settings.netcoredbg")
					-- require("custom.configs.dap.settings.godot")
					-- require("custom.configs.dap.settings.bash-debug-adapter")
					-- require("custom.configs.dap.settings.chrome-debug-adapter")
					-- require("custom.configs.dap.settings.firefox-debug-adapter")
					-- require("custom.configs.dap.settings.java-debug")
					-- require("custom.configs.dap.settings.node-debug2")
					-- require("custom.configs.dap.settings.debugpy")
					-- require("custom.configs.dap.settings.js-debug")
				end,
			},
		},
		opts = require("custom.configs.dap.ui"),
	},

	{
		"neovim/nvim-lspconfig",
		init = function()
			require("core.utils").lazy_load("nvim-lspconfig")
		end,
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		init = function()
			require("core.utils").lazy_load("indent-blankline.nvim")
		end,
		opts = overrides.blankline,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "blankline")
			require("indent_blankline").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		opts = overrides.treesitter,
	},

	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = overrides.oil,
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = true,
	},

	{
		"davvid/telescope-git-grep.nvim",
		branch = "main",
	},

	{
		"windwp/nvim-autopairs",
		enabled = false,
	},

	{ "NvChad/nvim-colorizer.lua", enabled = false },
}

return plugins
