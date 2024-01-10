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

-- nvim-tree auto_close
local function tab_win_closed(winnr)
	local api = require("nvim-tree.api")
	local tabnr = vim.api.nvim_win_get_tabpage(winnr)
	local bufnr = vim.api.nvim_win_get_buf(winnr)
	local buf_info = vim.fn.getbufinfo(bufnr)[1]
	local tab_wins = vim.tbl_filter(function(w)
		return w ~= winnr
	end, vim.api.nvim_tabpage_list_wins(tabnr))
	local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
	if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
		-- Close all nvim tree on :q
		if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
			api.tree.close()
		end
	else -- else closed buffer was normal buffer
		if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
			local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
			if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
				vim.schedule(function()
					if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
						vim.cmd("quit") -- then close all of vim
					else -- else there are more tabs open
						vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
					end
				end)
			end
		end
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		pcall(function()
			vim.lsp.buf.format({ async = false })
		end)
	end,
})

vim.api.nvim_create_autocmd("WinClosed", {
	callback = function()
		local winnr = tonumber(vim.fn.expand("<amatch>"))
		vim.schedule_wrap(tab_win_closed(winnr))
	end,
	nested = true,
})
