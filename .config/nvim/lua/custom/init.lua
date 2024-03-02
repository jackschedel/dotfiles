-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.opt.relativenumber = true
vim.cmd("map <LeftMouse> <nop>")
vim.cmd("map! <LeftMouse> <nop>")
vim.cmd("map <RightMouse> <nop>")
vim.cmd("map! <RightMouse> <nop>")
vim.cmd("map <2-LeftMouse> <nop>")
vim.cmd("map! <2-LeftMouse> <nop>")
vim.cmd("autocmd InsertEnter * set nohlsearch")
vim.cmd("autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab")
vim.cmd("autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab")
vim.cmd("autocmd VimLeave * mksession! ~/.Session.vim")
vim.cmd("set scrolloff=6")
vim.cmd(
	"autocmd BufRead,BufNewFile  * if (line('$') == 1 && getline(1) != '') | set nonumber norelativenumber | else | set number relativenumber | endif"
)
vim.api.nvim_set_keymap("", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("", "<C-u>", "<C-u>zz", { noremap = true })
vim.api.nvim_set_keymap("", "n", "nzzzv", { noremap = true })
vim.api.nvim_set_keymap("", "N", "Nzzzv", { noremap = true })
