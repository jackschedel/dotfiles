local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local root_pattern = require("plugins.configs.lspconfig").root_pattern
capabilities.offsetEncoding = "utf-8"

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "rust_analyzer", "gopls", "jedi_language_server", "tailwindcss" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		root_dir = root_pattern,
	})
end

lspconfig.omnisharp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/opt/omnisharp/OmniSharp", "--languageserver", "--hostPID", tostring(pid) },
})

lspconfig.clangd.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.signatureHelpProvider = false
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
})

-- vim.diagnostic.config {
--   virtual_text = {
--     prefix = "",
--   },
--   signs = false,
--   underline = true,
--   update_in_insert = false,
-- }
