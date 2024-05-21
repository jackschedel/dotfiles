-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "gruvbox",
  lsp_semantic_tokens = true,
  extended_integrations = { "dap", "bufferline" },
  telescope = { style = "bordered" },
  tabufline = {
    enabled = false,
  },
  transparency = true,
  statusline = {
    theme = "minimal",
    separator_style = "round",
    modules = {
      file = function()
        -- relative file path rather than just file name
        local icon = "󰈚 "
        local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
        local relpath = vim.fn.fnamemodify(path, ":.")
        local name = (relpath == "" and "Empty ") or relpath
        if name ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and ft_icon) or icon
          end
          name = " " .. name .. " "
        end
        return "%#StText# " .. icon .. name
      end,
      git = function()
        return ""
      end,
      cursor = function()
        return ""
      end,
    },
  },
}

M.plugins = "plugins"

return M
