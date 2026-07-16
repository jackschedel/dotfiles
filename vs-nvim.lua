-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.cmd "autocmd InsertEnter * set nohlsearch"
vim.opt.clipboard = "unnamed"
vim.opt.ignorecase = true
vim.g.mapleader = " "
vim.opt.smartcase = true
vim.cmd "set cmdheight=1"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "ggandor/leap.nvim",
      event = "VeryLazy",
      checker = { enabled = false },
      dependencies = { { "tpope/vim-repeat" } },
      config = function()
        require("leap").add_default_mappings()
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

local map = vim.keymap.set
local vscode = require('vscode')

map({ "n", "v" }, ";", ":")
map({ "n", "v" }, ":", ";")
map({ "n", "v" }, "c", '"_c')

map("v", "p", "pgvy")
map("v", "x", '"_d')
map("v", "<leader>d", '"_d')
map("v", "c", '"_c')
map("v", "Y", "ygv", { desc = "Yank (keep selection)" })


map("n", "x", '"_x')
map("n", "r", '"_r')
map("n", "X", '"_X')
map("n", "C", '"_C')
map("n", "<leader>d", '"_d')
map("n", "<leader>ff", function()
  vim.cmd "Telescope find_files"
end, { desc = "Files" })
map("n", "<leader>fw", function()
  vim.cmd "Telescope live_grep"
end, { desc = "Words" })
map("v", "<Tab>", ">gvll", { desc = "Indent line" })
map("v", "<S-Tab>", "<gvhh", { desc = "De-indent line" })
map("n", "<Tab>", "V>ll", { desc = "Indent line" })
map("n", "<S-Tab>", "V<hh", { desc = "De-indent line" })
map("n", "<leader>ga", function()
  pcall(function()
    vim.cmd "w"
  end)
  vim.cmd "silent ! git add -A"
end, { desc = "Stage all" })
map("n", "<leader>lf", function()
  vscode.action("editor.action.formatDocument")
end, { desc = "Format" })
map("v", "<leader>lf", function()
  vscode.action("editor.action.formatSelection")
end, { desc = "Format" })

map("n", "<leader>ff", function()
  vscode.action("workbench.action.quickOpen")
end, { desc = "Find Files" })

map("n", "<leader>fw", function()
  vscode.action("workbench.action.findInFiles")
end, { desc = "Find Words" })

map("n", "<leader>c", function()
  vscode.action("cline.focusChatInput")
end, { desc = "Cline" })

map("n", "<leader>e", function()
  vscode.action("workbench.view.explorer")
end, { desc = "Explorer" })