-- clipboard handling
-- and copy paste
---------------------

-- Use system clipboard for yank
-- and command v (in mac)
--
--  An alternative is to use + for all, but is not good for use when changes a text
--  See `:help 'clipboard'`
--      vim.opt.clipboard = 'unnamedplus'
vim.keymap.set({ "n", "v" }, "y", '"+y')
vim.keymap.set("n", "yy", '<S-V>"+y<esc>')
vim.keymap.set("i", "<C-r>r", "<C-r>+")
vim.keymap.set("c", "<C-r>r", "<C-r>+")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Esc remove search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<cr>", { silent = true })

-- Copy file an lines: useful to indicate part of code to an IA
local function copy_file_location()
  local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local mode = vim.fn.mode()
  local result

  if mode == "v" or mode == "V" or mode == "\22" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    if start_line == end_line then
      result = filepath .. " line " .. start_line
    else
      result = filepath .. " line " .. start_line .. " to line " .. end_line
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  else
    result = filepath
  end

  vim.fn.setreg("+", result)
  vim.notify(result, vim.log.levels.INFO)
end

vim.keymap.set({ "n", "v" }, "<leader>yf", copy_file_location, { desc = "Copy file path with line number" })
