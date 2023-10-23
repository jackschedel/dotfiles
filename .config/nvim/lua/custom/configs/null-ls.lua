local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {

	b.formatting.prettier,

	b.formatting.stylua,

	b.formatting.clang_format,

	b.formatting.gofmt,

	b.formatting.black,

	b.formatting.asmfmt,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
