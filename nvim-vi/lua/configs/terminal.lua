vim.keymap.set('n', '<leader>te', ':botright vsp term://zsh<cr>')

local terminal_mode = vim.api.nvim_create_augroup('terminal_mode', { clear = true })

local opts = { noremap = true, silent = true }

vim.api.nvim_create_autocmd('TermOpen', {
  command = ':startinsert',
  group = terminal_mode,
})

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', '<c-\\><c-n>', opts)
  end,
  group = terminal_mode,
})

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', 'gq', ':bd!<cr>', opts)
  end,
  group = terminal_mode,
})

vim.api.nvim_create_autocmd('TermOpen', {
  command = ':setlocal nonumber nocursorline',
  group = terminal_mode,
})
