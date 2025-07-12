return {
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
  },

  { "akinsho/toggleterm.nvim", opts = {}, cmd = { "ToggleTerm", "TermExec" } },

  {
    "yetone/avante.nvim",
    cmd = { "AvanteAsk" },
    version = false,
    config = function(_, opts)
      -- load avante tokenizers and templates
      require("avante_lib").load()

      require("avante").setup(opts)
    end,
    opts = {
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      -- provider = "copilot",
      provider = "openai",
      openai = {
        endpoint = "https://openrouter.ai/api/v1",
        model = "anthropic/claude-3.5-sonnet:beta",
        api_key_name = "OPENROUTER_API_KEY_AVANTE",
        temperature = 0.7,
        max_tokens = 8192,
      },
      mappings = {
        ask = nil,
        edit = nil,
        refresh = nil,
      },
      hints = { enabled = false },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot", "Avante" },
        opts = {
          filetypes = {
            ["*"] = false,
          },
        },
      },
      {
        "HakonHarnes/img-clip.nvim",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  { "lukas-reineke/indent-blankline.nvim", event = "VeryLazy" },

  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
  },

  {
    "Tyler-Barham/floating-help.nvim",
    cmd = "FloatingHelp",
    opts = {
      width = 0.8, -- Whole numbers are columns/rows
      height = 0.8, -- Decimals are a percentage of the editor
      position = "C", -- NW,N,NW,W,C,E,SW,S,SE (C==center)
      border = "rounded", -- rounded,double,single
    },
  },

  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    opts = {
      include_match_words = true,
    },
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_surround_enabled = 0

      vim.api.nvim_set_hl(0, "MatchWordCur", { ctermfg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "MatchWord", { fg = "NONE", bg = "NONE", underline = true })
      vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ebdbb2", bg = "#4b4b4b" })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "modern", icons = { rules = false, group = "" } },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      local wk = require "which-key"
      wk.setup(opts)
      wk.add {
        { "<leader>f", group = "Find", icon = " " },
        { "<leader>s", group = "Avante", icon = " " },
        { "<leader>C", group = "Settings", icon = " " },
        { "<leader>D", group = "Debug", icon = " " },
        { "<leader>g", group = "Git", icon = " " },
        { "<leader>l", group = "LSP", icon = " " },
        { "<leader>lw", group = "Workspaces", icon = " " },
        {
          -- Prevents which-key overwriting when opening `c` or `d` display
          mode = { "n" },
          { "c", '"_c' },
          { "ci", '"_ci' },
          { "ca", '"_ca' },
          { "c_", 'v0w"_c' },
          { "d_", "v_d" },
        },
      }
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },

  { "Hoffs/omnisharp-extended-lsp.nvim", ft = { "cs" } },

  {
    "lewis6991/gitsigns.nvim",
    opts = { on_attach = function() end },
  },

  { import = "nvchad.blink.lazyspec" },

  {
    "Saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<S-Tab>"] = false,
        ["<Tab>"] = { "accept", "fallback" },
      },
    },
  },

  {
    "numToStr/Navigator.nvim",
    cmd = { "NavigatorLeft", "NavigatorDown", "NavigatorUp", "NavigatorRight" },
    opts = {},
  },

  {
    "ThePrimeagen/git-worktree.nvim",
    event = "VeryLazy",
  },

  { "mbbill/undotree", event = "VeryLazy" },

  "NvChad/nvcommunity",
  { import = "nvcommunity.editor.hlargs" },

  {
    "nvim-treesitter/nvim-treesitter-context",
    -- todo commit hardcode unnesecary once major bug introduced in main is fixed :)
    commit = "0dd00bb6423b4c655e6a0f9dd2f5332167bb6d33",
    opts = {
      throttle = true,
      max_lines = 2,
      multiline_threshold = 1,
      trim_scope = "inner",
      mode = "topline",
    },
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if not vim.tbl_contains({ "cs", "", "Avante", "AvanteInput" }, vim.bo.ft) then
            require("treesitter-context").setup()
          end
        end,
      })
    end,
  },

  {
    "kevinhwang91/nvim-fundo",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      vim.o.undofile = true
      require("fundo").setup()
    end,
    build = function()
      require("fundo").install()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "davvid/telescope-git-grep.nvim",
    },
    opts = {
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
    },
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
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        -- javascript = { "prettierd" },
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
      format_on_save = { timeout_ms = 500 },
      formatters = {
        clang_format = { prepend_args = { "-style=file:/home/jack/.config/nvim/.clang-format" } },
      },
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
    dependencies = {
      { "nvim-neotest/nvim-nio" },
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
          require "configs.dap.codelldb"
          require "configs.dap.go"
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
    lazy = false,
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

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
        "pony",
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
    opts = { view_options = { show_hidden = true } },
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "windwp/nvim-autopairs",
    enabled = false,
  },

  { "NvChad/nvim-colorizer.lua", enabled = false },
}
