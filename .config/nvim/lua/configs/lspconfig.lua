local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
capabilities.offsetEncoding = "utf-8"

local lspconfig = require "lspconfig"

local servers = {
  "html",
  "cssls",
  "gopls",
  "jedi_language_server",
  "intelephense",
  "csharp_ls",
  "ts_ls",
}

local function BaseOnAttach()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = BaseOnAttach,
    capabilities = capabilities,
    on_init = on_init,
  }
end

lspconfig.omnisharp.setup {
  on_attach = BaseOnAttach,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = require("omnisharp_extended").handler,
  },
  on_init = on_init,
  cmd = { "omnisharp", "--languageserver" },
  root_dir = function()
    return require("lspconfig/util").root_pattern("*.csproj", "omnisharp.json", "*.godot", "function.json")(
      vim.fn.expand "%:p:h"
    ) or vim.fn.expand "%:p:h"
  end,
}

lspconfig.clangd.setup {
  on_attach = function(client, _)
    BaseOnAttach()
    client.server_capabilities.signatureHelpProvider = false
  end,
  capabilities = capabilities,
  on_init = on_init,
}

lspconfig.lua_ls.setup {
  on_attach = BaseOnAttach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
