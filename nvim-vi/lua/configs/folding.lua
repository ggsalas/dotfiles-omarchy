function GGsalasFoldStyle()
  local foldstart = vim.v.foldstart
  local foldend = vim.v.foldend
  local line = vim.fn.getline(foldstart)

  local nucolwidth = vim.wo.foldcolumn + (vim.wo.number and vim.wo.numberwidth or 0)
  local windowwidth = vim.fn.winwidth(0) - nucolwidth - 3
  local foldedlinecount = (foldend - foldstart) .. " lines  "

  -- expand tabs into spaces
  local tabstop = vim.bo.tabstop
  line = line:gsub("\t", function()
    return string.rep(" ", tabstop)
  end)

  line = line:sub(1, windowwidth - 2 - #foldedlinecount) .. " "
  local fillcharcount = windowwidth - #line - #foldedlinecount

  return line .. string.rep(".", fillcharcount) .. " " .. foldedlinecount
end

vim.api.nvim_create_user_command("FoldSyntax", function()
  vim.opt.foldmethod = "syntax"
  vim.opt.foldlevel = 0
end, {})

vim.api.nvim_create_user_command("FoldExpr", function()
  vim.opt.foldmethod = "expr"
  vim.opt.foldlevel = 0
end, {})

vim.api.nvim_create_user_command("FoldManual", function()
  vim.opt.foldmethod = "manual"
  vim.opt.foldlevel = 0
end, {})

vim.api.nvim_create_user_command("FoldDiff", function()
  vim.opt.foldmethod = "diff"
  vim.opt.foldlevel = 0
end, {})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = "GGsalasFoldStyle()"
vim.opt.foldlevel = 99

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldtext = "GGsalasFoldStyle()"
    vim.wo.foldlevel = 99
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<Tab>", "zA", { buffer = true, desc = "Toggle fold recursive" })
  end,
})
