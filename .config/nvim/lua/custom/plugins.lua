local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{ "ThePrimeagen/harpoon", lazy = false },

	{ "ThePrimeagen/git-worktree.nvim" },

	{ "mbbill/undotree", lazy = false },

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
			require("core.utils").load_mappings("Dap")
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
					require("custom.configs.dap.settings.cpptools")
					-- require("custom.configs.dap.settings.codelldb")

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
		dependencies = {
			-- format & linting
			{
				"nvimtools/none-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
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

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	-- To make a plugin not be loaded
	{
		"windwp/nvim-autopairs",
		enabled = false,
	},

	{
		"davvid/telescope-git-grep.nvim",
		branch = "main",
	},

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
