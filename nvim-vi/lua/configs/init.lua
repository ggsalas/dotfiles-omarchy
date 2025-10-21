require("configs.folding")
require("configs.help")
require("configs.markdown")
require("configs.quickfix")
require("configs.remap")
require("configs.set")
require("configs.spell")
require("configs.tabs")
require("configs.terminal")
require("configs.diagnostics")
require("configs.clipboard")

vim.keymap.set("n", "<leader>/", function()
  local bg = vim.o.background
  vim.o.background = (bg == "dark") and "light" or "dark"
  local cs = vim.g.colors_name
  if cs and #cs > 0 then
    pcall(vim.cmd, "colorscheme " .. cs)
    pcall(dofile, vim.fn.stdpath("config") .. "/plugin/after/transparency.lua")
  end
  print("Background: " .. vim.o.background)
end, { desc = "Toggle background" })
