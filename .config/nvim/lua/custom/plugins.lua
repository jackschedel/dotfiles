local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"ThePrimeagen/harpoon",
		lazy = false,
		config = function()
			require("core.utils").load_mappings("Harpoon")
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^3", -- Recommended
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
		config = function(_, opts)
			-- table.insert(opts.sources, { name = "cody" })
			require("cmp").setup(opts)
		end,
		dependencies = {
			{
				"sourcegraph/sg.nvim",
				event = "VeryLazy",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},

				config = function()
					require("sg").setup({
						on_attach = require("plugins.configs.lspconfig").on_attach,
					})
				end,
			},
		},
	},

	{
		"numToStr/Navigator.nvim",
		lazy = false,
		config = function()
			require("Navigator").setup()
		end,
	},

	{ "ThePrimeagen/git-worktree.nvim" },

	{ "mbbill/undotree", lazy = false },

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
		event = "BufReadPost",
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
				typescriptreact = { "prettierd" },
				javascriptreact = { "prettierd" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cuda = { "clang_format" },
				cs = { "clang_format" },
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true, quiet = true },
			formatters = { clang_format = { prepend_args = { "-style=file:/Users/jack/.config/nvim/.clang-format" } } },
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"ggandor/leap.nvim",
		lazy = false,
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

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		version = "2.20.7",
		init = function()
			require("core.utils").lazy_load("indent-blankline.nvim")
		end,
		opts = overrides.blankline,
		config = function(_, opts)
			require("core.utils").load_mappings("blankline")
			dofile(vim.g.base46_cache .. "blankline")
			require("indent_blankline").setup(opts)
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"davvid/telescope-git-grep.nvim",
		branch = "main",
	},

	-- To make a plugin not be loaded
	{
		"windwp/nvim-autopairs",
		enabled = false,
	},

	{ "NvChad/nvim-colorizer.lua", enabled = false },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
