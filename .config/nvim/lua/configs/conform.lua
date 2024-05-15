local options = {
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
  formatters = {
    clang_format = { prepend_args = { "-style=file:~/.config/nvim/.clang-format" } },
  },
}

require("conform").setup(options)
