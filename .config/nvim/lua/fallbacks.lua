-- basic crutches I want even if I mess up mappings.lua and it won't load

local map = vim.keymap.set

map({ "n", "v" }, ";", ":")
map({ "n", "v" }, ":", ";")
map("v", "p", "pgvy")

map({ "n", "v" }, "n", "nzzzv")
map({ "n", "v" }, "N", "Nzzzv")
map("c", "<CR>", function()
  if vim.fn.getcmdtype() == "/" then
    return "<CR>zzzv"
  end
  return "<CR>"
end, { expr = true })

map("n", "<leader>ff", function()
  vim.cmd "Telescope find_files"
end, { desc = "Files" })

map("n", "<leader>fw", function()
  vim.cmd "Telescope live_grep"
end, { desc = "Words" })
