local function map(mode, lhs, rhs, opts)
  opts = opts or {} -- Ensure opts is a table if not provided
  if opts.desc == nil then -- If desc is not provided
    opts.desc = "which_key_ignore" -- Set default desc value
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

local function Format()
  require("conform").format { async = true, lsp_fallback = true }
end

local function JumpContext(to_top)
  local ok, start, finish = require("indent_blankline.utils").get_current_context(
    vim.g.indent_blankline_context_patterns,
    vim.g.indent_blankline_use_treesitter_scope
  )
  if ok then
    local target_line = to_top and start or finish
    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { target_line, 0 })
  end
  if to_top then
    vim.cmd [[normal! _]]
  else
    vim.cmd [[normal! $]]
  end
end

local function VFit()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local max_width = 0
  for _, line in ipairs(lines) do
    local width = vim.fn.strdisplaywidth(line)
    if width > max_width then
      max_width = width
    end
  end
  vim.cmd("vertical resize " .. max_width + 6)
end

local function HFit()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local max_height = #lines
  vim.cmd("resize " .. max_height + 1)
end

-- NvChad mappings
map("n", "<leader>Cr", "<cmd> source ~/.Session.vim <CR>", { desc = "Restore Session" })
map("n", "<leader>Ce", "<cmd> Telescope help_tags <CR>", { desc = "Search help" })
map("n", "<leader>Ct", "<cmd> Telescope themes <CR>", { desc = "Theme picker" })

-- Git mappings
map("n", "<leader>ga", function()
  pcall(function()
    vim.cmd "w"
  end)
  vim.cmd "silent ! git add -A"
end, { desc = "Stage all" })

map("n", "<leader>gb", function()
  require("gitsigns").blame_line()
end, { desc = "Git blame" })

map("n", "<leader>gd", function()
  require("gitsigns").toggle_deleted()
end, { desc = "View deleted" })

map("n", "<leader>gg", function()
  pcall(function()
    vim.cmd "w"
  end)
  vim.cmd "LazyGit"
end, { desc = "LazyGit" })

map("n", "gD", vim.lsp.buf.declaration, { desc = "Lsp Go to declaration" })
map("n", "K", vim.lsp.buf.hover, { desc = "Lsp hover information" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Lsp Go to implementation" })
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Lsp Add workspace folder" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Lsp Remove workspace folder" })
map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "Lsp List workspace folders" })

map("n", "<leader>lE", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Diagnostics in file" })

-- Lsp Mappings
map("n", "gr", function()
  vim.cmd "Telescope lsp_references"
end, { desc = "LSP references" })

map("n", "gd", function()
  local locations = vim.lsp.buf_request_sync(0, "textDocument/definition", vim.lsp.util.make_position_params(), 1000)
  if not locations or vim.tbl_isempty(locations) then
    return
  end

  local original_location_count = 0
  local in_node_modules = false
  for _, server_locations in pairs(locations) do
    for _, loc in ipairs(server_locations.result) do
      original_location_count = original_location_count + 1
      local uri = loc.uri or loc.targetUri
      if string.find(vim.uri_to_fname(uri), "node_modules") then
        in_node_modules = true
      else
        in_node_modules = false
      end
    end
  end

  if original_location_count == 1 and in_node_modules then
    print "Definition in node_modules"
    return
  end

  for _, server_locations in pairs(locations) do
    for i = #server_locations.result, 1, -1 do
      local uri = server_locations.result[i].uri or server_locations.result[i].targetUri
      if string.find(vim.uri_to_fname(uri), "node_modules") then
        table.remove(server_locations.result, i)
      end
    end
  end

  local filtered_locations = locations[1] and locations[1].result
  if not filtered_locations or vim.tbl_isempty(filtered_locations) then
    return
  end

  if #filtered_locations == 1 then
    vim.lsp.util.jump_to_location(filtered_locations[1], "utf-8")
    return
  end

  vim.cmd "Telescope lsp_definitions"
end, { desc = "LSP definitions" })

map("n", "<leader>lu", "<cmd> Telescope lsp_references <CR>", { desc = "Usages" })
map("n", "<leader>ls", "<cmd> LspStop <CR>", { desc = "Stop LSP" })

map("n", "<leader>la", function()
  local current_ft = vim.bo.filetype
  if current_ft == "rust" then
    vim.cmd.RustLsp "codeAction"
  else
    vim.lsp.buf.code_action()
  end
end, { desc = "Code action" })

map("n", "<leader>lr", function()
  require "nvchad.lsp.renamer"()
end, { desc = "Rename" })

map("n", "<leader>le", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Diagnostic" })

map("n", "<leader>ll", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor_pos[1] - 1
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_line })
  if #diagnostics > 0 then
    vim.cmd "normal yy"
    local diag_text = "Diagnostics:\n"
    for _, diag in ipairs(diagnostics) do
      diag_text = diag_text .. diag.message .. "\n"
    end
    local current_line = vim.fn.getreg "*"
    vim.fn.setreg("*", current_line .. "\n" .. diag_text)
  end
end, { desc = "Copy diagnostics" })

map("n", "<leader>lf", function()
  Format()
end, { desc = "Format" })

map("n", "<leader>lA", function()
  local exts = {
    "ts",
    "tsx",
    "js",
    "jsx",
    "html",
    "css",
    "md",
    "yaml",
    "scss",
    "json",
    "yml",
    "lua",
    "c",
    "py",
    "cpp",
    "asm",
  }
  for _, ext in ipairs(exts) do
    local files = vim.fn.glob("**/*." .. ext)
    if #files > 0 then
      vim.cmd("args **/*." .. ext)
    end
  end
end, { desc = "Open all src files" })

-- General mappings
-- Visual mode mappings
map("v", ";", ":", { desc = "enter cmdline", nowait = true })
map("v", ":", ";", { nowait = true })
map("v", ",", "<", { nowait = true })
map("v", "<", ",", { nowait = true, noremap = true })
map("v", "x", '"_d')
map("v", "<leader>d", '"_d')
map("v", "c", '"_c')
map("v", "Y", "ygv", { desc = "Yank (keep selection)" })
map("v", "<Tab>", ">llgv", { desc = "Indent line" })
map("v", "<S-Tab>", "<hhgv", { desc = "De-indent line" })
map("v", "<leader>o", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
end, { desc = "Add spacing around" })

map("v", "<leader>]", function()
  vim.cmd "normal! oh"
  JumpContext(true)
  vim.cmd "normal VV"
  JumpContext(false)
end, { desc = "Select Block (treesitter)" })

map("v", "<leader>[", "okV%", { desc = "Select Matching Block" })

map("n", "x", '"_x')
map("n", "r", '"_r')
map("n", "X", '"_X')
map("n", "C", '"_C')
map("n", "<leader>d", '"_d')
map("n", "{", function()
  vim.cmd "normal h"
  JumpContext(true)
end, { desc = "Context start", nowait = true })

map("n", "}", function()
  vim.cmd "normal l"
  JumpContext(false)
end, { desc = "Context end", nowait = true })

map("n", ";", ":", { desc = "enter cmdline", nowait = true })
map("n", ":", ";", { nowait = true })
map("n", ",", "<", { nowait = true })
map("n", "<", ",", { nowait = true, noremap = true })
map("n", "<C-s>", "<cmd> noautocmd w <CR>", { desc = "Save file (no autocmd)" })
map("n", "<leader>[", "$V%", { desc = "Select Matching Block" })
map("n", "<leader>]", function()
  JumpContext(true)
  vim.cmd "normal V"
  JumpContext(false)
end, { desc = "Select Block (treesitter)" })

map("n", "gt", function()
  vim.lsp.buf.type_definition()
end, { desc = "LSP type definition" })

map("n", "I", function()
  vim.cmd "normal _"
  vim.cmd "startinsert"
end)

map({ "n", "v" }, "<C-h>", "<Cmd>NavigatorLeft<CR>")
map({ "n", "v" }, "<C-j>", "<Cmd>NavigatorDown<CR>")
map({ "n", "v" }, "<C-k>", "<Cmd>NavigatorUp<CR>")
map({ "n", "v" }, "<C-l>", "<Cmd>NavigatorRight<CR>")
map("n", "<S-Left>", "2<C-W><")
map("n", "<S-Up>", "2<C-W>+")
map("n", "<S-Down>", "2<C-W>-")
map("n", "<S-Right>", "2<C-W>>")
map("n", "<C-W>v", function()
  VFit()
end, { desc = "Vertical scale to fit" })

map("n", "<C-W>h", function()
  HFit()
end, { desc = "Horizontal scale to fit" })

map("n", "<leader>o", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
end, { desc = "Add spacing around" })

map("n", "<leader>R", "<cmd> Spectre <CR>", { desc = "SSR" })
map("n", "<leader>m", "<cmd> Telescope marks <CR>", { desc = "Marks" })
map("n", "<leader>N", "<cmd> enew <CR>", { desc = "New buffer" })
map("n", "<leader>p", function()
  vim.cmd "normal o"
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { "" })
  vim.cmd "normal pk"
  Format()
end, { desc = "Paste pretty" })

map("n", "<leader>u", function()
  vim.cmd "UndotreeToggle"
end, { desc = "Undotree" })

map("n", "<Tab>", "V>ll", { desc = "Indent line" })
map("n", "<S-Tab>", "V<hh", { desc = "De-indent line" })

map("n", "<leader>fg", function()
  local success, _ = pcall(function()
    vim.cmd "Telescope git_files"
  end)

  if not success then
    vim.cmd "Telescope find_files"
  end
end, { desc = "Find repo files" })

map("n", "<leader>fa", function()
  vim.cmd "Telescope find_files no_ignore=true hidden=true"
end, { desc = "Find all files" })

map("n", "<leader>fl", function()
  local success, _ = pcall(function()
    vim.cmd "Telescope git_grep live_grep"
  end)

  if not success then
    vim.cmd "Telescope live_grep"
  end
end, { desc = "Grep in repo" })

map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Grep current buffer" })
map("n", "<leader>P", function()
  vim.cmd "normal ggVGP"
end, { desc = "Paste buffer" })

map("n", "<leader>v", function()
  vim.cmd "vnew"
end)

map("n", "<leader>h", function()
  vim.cmd "new"
end)

map("n", "<leader>V", function()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_pos = vim.api.nvim_win_get_cursor(cur_win)
  vim.cmd "vsplit %"
  local new_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_cursor(new_win, cur_pos)
end)

map("n", "<leader>H", function()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_pos = vim.api.nvim_win_get_cursor(cur_win)
  vim.cmd "split %"
  local new_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_cursor(new_win, cur_pos)
end)

map("n", "<leader>e", "<cmd>Oil --float<CR>", { desc = "Toggle explorer" })
map("n", "<F3>", function()
  pcall(function()
    vim.cmd "w"
  end)
  local run_script = "./.nvim-run.sh"
  if vim.fn.filereadable(run_script) == 1 then
    vim.fn.system("chmod +x " .. run_script .. " > /dev/null 2>&1")
    vim.fn.system(run_script)
    return
  end
end, { desc = "Run Script" })

map("n", "<F4>", function()
  vim.cmd "silent ! explorer.exe ."
end, { desc = "Open Explorer Here" })

map("n", "<F5>", function()
  pcall(function()
    vim.cmd "w"
  end)
  local run_script = "./.nvim-run.sh"
  if vim.fn.filereadable(run_script) == 1 then
    vim.fn.system("chmod +x " .. run_script .. " > /dev/null 2>&1")
    require("nvterm.terminal").new "float"
    require("nvterm.terminal").send(run_script)
    vim.cmd "startinsert"
    return
  end

  local current_ft = vim.bo.filetype
  if current_ft == "rust" then
    vim.cmd.RustLsp { "runnables", bang = true }
  elseif current_ft == "go" then
    local current_file = vim.fn.expand "%:p"
    local relative_path = vim.fn.fnamemodify(current_file, ":.:.")
    vim.cmd("!go run " .. relative_path)
  end
end, { desc = "Run Script" })

map("n", "<F6>", function()
  local tabs = vim.api.nvim_list_tabpages()
  for _, tab in ipairs(tabs) do
    local windows = vim.api.nvim_tabpage_list_wins(tab)
    for _, win in ipairs(windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      vim.fn.bufload(buf)
      vim.api.nvim_set_current_win(win)
      local success = false
      success, _ = pcall(function()
        vim.cmd "w"
        local current_ft = vim.bo.filetype
        if current_ft == "rust" then
          vim.cmd.RustLsp { "debuggables", bang = true }
        else
          require("dap").continue()
        end
      end)
      if success then
        return
      end
    end
  end
end, { desc = "Debug" })

map("n", "<F7>", function()
  require("dap").step_over()
end, { silent = true, desc = "Step Over" })

-- Multiple register y and p binds
for i = 1, 9 do
  local iStr = tostring(i)
  map("n", iStr .. "y", '"' .. iStr .. "y", { noremap = true })
  map("n", iStr .. "Y", '"' .. iStr .. "Y", { noremap = true })
  map("v", iStr .. "y", '"' .. iStr .. "y", { noremap = true })
  map("v", iStr .. "Y", '"' .. iStr .. "ygv", { noremap = true })

  map("n", iStr .. "d", '"' .. iStr .. "d", { noremap = true })
  map("n", iStr .. "D", '"' .. iStr .. "D", { noremap = true })
  map("v", iStr .. "d", '"' .. iStr .. "d", { noremap = true })

  map("n", iStr .. "p", '"' .. iStr .. "p", { noremap = true })
  map("n", iStr .. "P", '"' .. iStr .. "P", { noremap = true })
  map("v", iStr .. "p", '"' .. iStr .. "p", { noremap = true })
end

-- DAP Mappings
map("n", "<leader>Dc", function()
  require("dap").continue()
end, { silent = true, desc = "Continue" })

map("n", "<leader>Do", function()
  require("dap").step_over()
end, { silent = true, desc = "Step Over" })

map("n", "<leader>Di", function()
  require("dap").step_into()
end, { silent = true, desc = "Step Into" })

map("n", "<leader>Du", function()
  require("dap").step_out()
end, { silent = true, desc = "Step Out" })

map("n", "<leader>Db", function()
  require("dap").toggle_breakpoint()
end, { silent = true, desc = "Breakpoint" })

map("n", "<leader>DB", function()
  require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { silent = true, desc = "Breakpoint Condition" })

map("n", "<leader>DD", "<cmd>lua require'dapui'.toggle()<cr>", { silent = true, desc = "Dap UI" })
map("n", "<leader>Dl", "<cmd>lua require'dap'.run_last()<cr>", { silent = true, desc = "Run Last" })

-- Harpoon Mappings
map("n", "<leader>a", function()
  require("harpoon.mark").add_file()
end)

map("n", "<leader>q", function()
  require("harpoon.ui").toggle_quick_menu()
end)

for i = 1, 6 do
  map("n", "<leader>" .. i, function()
    require("harpoon.ui").nav_file(i)
  end)

  map("n", "<leader>" .. ({ "!", "@", "#", "$", "%", "^" })[i], function()
    -- auto determine based on aspect ratio
    if (vim.o.columns / vim.o.lines) > 2.4 then
      vim.cmd "vnew"
      require("harpoon.ui").nav_file(i)
      VFit()
    else
      vim.cmd "new"
      require("harpoon.ui").nav_file(i)
      HFit()
    end
  end)
end

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "File Copy whole" })

map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment Toggle" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

map({ "n" }, "<leader>t", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle Floating term" })

map("t", "<ESC>", function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(win, true)
end, { desc = "Terminal Close term in terminal mode" })
