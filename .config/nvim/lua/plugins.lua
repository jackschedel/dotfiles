return {
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
  },

  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    config = function()
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_surround_enabled = 0
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = require("nvchad.configs.lspconfig").on_attach,
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },

  { "Hoffs/omnisharp-extended-lsp.nvim", ft = { "cs" } },

  {
    "lewis6991/gitsigns.nvim",
    opts = { on_attach = function() end },
  },

  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    opts = {
      mapping = {
        ["<Tab>"] = require("cmp").mapping.confirm {
          behavior = require("cmp").ConfirmBehavior.Insert,
          select = true,
        },
        ["<CR>"] = require("cmp").config.disable,
        ["<S-Tab>"] = require("cmp").config.disable,
      },
    },

    dependencies = {
      "luckasRanarison/tailwind-tools.nvim",
      "onsails/lspkind-nvim",
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      },
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
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
    "nvim-telescope/telescope.nvim",
    init = function()
      require("telescope").setup {
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
      }
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
      require("telescope").load_extension "lazygit"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require "configs.conform"
    end,
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
    dependencies = {
      {
        "mfussenegger/nvim-dap",
        config = function()
          local dap = require "dap"
          vim.fn.sign_define(
            "DapBreakpoint",
            { text = "🛑", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
          )

          local dapui = require "dapui"
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
          -- require("configs.dap.settings.cpptools")
          require "configs.dap.codelldb"
          require "configs.dap.go"

          -- Disabled:
          -- require("configs.dap.settings.netcoredbg")
          -- require("configs.dap.settings.godot")
          -- require("configs.dap.settings.bash-debug-adapter")
          -- require("configs.dap.settings.chrome-debug-adapter")
          -- require("configs.dap.settings.firefox-debug-adapter")
          -- require("configs.dap.settings.java-debug")
          -- require("configs.dap.settings.node-debug2")
          -- require("configs.dap.settings.debugpy")
          -- require("configs.dap.settings.js-debug")
        end,
      },
    },
    opts = {
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40, -- 40 columns
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "css-lsp",
        "html-lsp",
        "isort",
        "black",
        "typescript-language-server",
        "deno",
        "prettierd",
        "clangd",
        "go",
        "clang-format",
        "rust-analyzer",
        "omnisharp",
        "gopls",
        "intelephense",
        "jedi-language-server",
        "tailwindcss-language-server",
        "prisma",
      },
    },
  },

  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   version = "^2",
  --   opts = {
  --     indentLine_enabled = 1,
  --     filetype_exclude = {
  --       "help",
  --       "terminal",
  --       "lazy",
  --       "lspinfo",
  --       "TelescopePrompt",
  --       "TelescopeResults",
  --       "mason",
  --       "nvdash",
  --       "nvcheatsheet",
  --       "",
  --     },
  --     buftype_exclude = { "terminal" },
  --     show_trailing_blankline_indent = false,
  --     show_first_indent_level = true,
  --     show_current_context = true,
  --     show_current_context_start = false,
  --     show_current_context_start_on_current_line = false,
  --   },
  --   config = function(_, opts)
  --     dofile(vim.g.base46_cache .. "blankline")
  --     require("indent_blankline").setup(opts)
  --   end,
  -- },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
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
        "prisma",
      },
      indent = {
        enable = true,
        disable = {
          "python",
        },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    opts = {},
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
