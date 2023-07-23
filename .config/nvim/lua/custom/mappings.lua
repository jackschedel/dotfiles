---@type MappingsTable
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
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>v"] = {
      function()
        vim.cmd "vnew"
      end,
      "Vertical Split",
    },
    ["<leader>h"] = {
      function()
        vim.cmd "new"
      end,
      "Horizontal Split",
    },
    ["<leader>V"] = {
      function()
        vim.cmd "vsplit #"
      end,
      -- Vertical Split (Clone)
      "which_key_ignore",
    },
    ["<leader>H"] = {
      function()
        vim.cmd "split #"
      end,
      -- Horizontal Split (Clone)
      "which_key_ignore",
    },
    ["<leader>tv"] = {
      function()
        require("nvterm.terminal").new "vertical"
      end,
      "Vertical Terminal Split",
    },
    ["<leader>th"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "Horizontal Terminal Split",
    },
    ["<leader>lf"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },
    ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle Explorer" },
    ["<leader>tm"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
    ["<leader>tp"] = { "<cmd> Telescope themes <CR>", "Theme Picker" },
    ["<F5>"] = {
      function()
        vim.cmd "!./nvim-run.sh"
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
  },
}

-- more keybinds!

return M
