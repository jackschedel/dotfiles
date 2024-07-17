require "nvchad.options"

-- autocmds
vim.cmd "autocmd InsertEnter * set nohlsearch"
vim.cmd "autocmd BufEnter * set formatoptions=jcql"
vim.cmd "autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab"
vim.cmd "autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab"
vim.cmd "autocmd VimLeave * mksession! ~/.Session.vim"
vim.cmd "autocmd BufRead,BufNewFile  * if (line('$') == 1 && getline(1) != '') | set nonumber norelativenumber | else | set number relativenumber | endif"

local o = vim.opt
o.relativenumber = true
o.scrolloff = 6

vim.cmd "map <LeftMouse> <nop>"
vim.cmd "map! <LeftMouse> <nop>"
vim.cmd "map <RightMouse> <nop>"
vim.cmd "map! <RightMouse> <nop>"
vim.cmd "map <2-LeftMouse> <nop>"
vim.cmd "map! <2-LeftMouse> <nop>"
vim.cmd "map <3-LeftMouse> <nop>"
vim.cmd "map! <3-LeftMouse> <nop>"
