vim.keymap.set("n", "<leader>tet", ":tabnew | terminal<cr>i", { desc = "New terminal tab" })
vim.keymap.set("n", "<leader>tev", ":botright vsp term://zsh<cr>i")
vim.keymap.set("n", "<leader>tes", ":botright sp term://zsh<cr>i")

-- Terminal mode configuration
local terminal_mode = vim.api.nvim_create_augroup("terminal_mode", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_mode,
  callback = function()
    -- Remove line numbers and cursorline
    vim.opt_local.number = false
    vim.opt_local.cursorline = false

    -- Terminal mode keymaps
    local opts = { buffer = 0, silent = true, nowait = true }
    vim.keymap.set("t", "<C-;>", "<c-\\><c-n>", opts) -- Exit terminal mode
    vim.keymap.set("t", "<Space>", "<Space>", opts) -- No leader delay

    -- Normal mode keymaps (when in terminal buffer but not in terminal mode)
    vim.keymap.set("n", "gq", ":bd!<cr>", opts) -- Quit terminal buffer
  end,
})
