-- basic crutches I want even if I mess up mappings.lua and it won't load
--
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("v", "p", "pgvy")

map({ "n", "v" }, "n", "nzzzv")
map({ "n", "v" }, "N", "Nzzzv")

map("n", "<leader>ff", function()
  vim.cmd "Telescope find_files"
end, { desc = "Find files" })

map("n", "<leader>fw", function()
  vim.cmd "Telescope live_grep"
end, { desc = "Grep files" })
