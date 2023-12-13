local present, null_ls = pcall(require, "null-ls")
local clang_format_config = vim.fn.stdpath("config") .. "/.clang-format"

if not present then
	return
end

local b = null_ls.builtins

local sources = {

	b.formatting.prettier,

	b.formatting.stylua,

	b.formatting.clang_format.with({
		extra_args = { "-style=file:" .. clang_format_config },
	}),

	b.formatting.gofmt,

	b.formatting.rustfmt,

	b.formatting.black,

	b.formatting.asmfmt,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
