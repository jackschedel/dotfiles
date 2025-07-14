local servers = {
  "html",
  "cssls",
  "gopls",
  "jedi_language_server",
  "intelephense",
  "csharp_ls",
  "ts_ls",
  "lua_ls",
  "clangd",
  "omnisharp",
}

vim.lsp.config("omnisharp", {
  handlers = {
    ["textDocument/definition"] = require("omnisharp_extended").handler,
  },
  cmd = { "omnisharp", "--languageserver" },
  root_dir = function()
    return require("lspconfig/util").root_pattern("*.csproj", "omnisharp.json", "*.godot", "function.json")(
      vim.fn.expand "%:p:h"
    ) or vim.fn.expand "%:p:h"
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      -- diagnostics = {
      --   globals = { "vim" },
      -- },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
        -- maxPreload = 100000,
        -- preloadFileSize = 10000,
      },
    },
  },
})

vim.lsp.enable(servers)
