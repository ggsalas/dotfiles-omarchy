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
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Esc remove search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<cr>", { silent = true })

