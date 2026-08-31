-- replace and save quick fix list
vim.api.nvim_create_user_command('QuickFix', ':copen', {})
vim.api.nvim_create_user_command('QuickFixDoMacro', ':cdo %s/<args>', { nargs = 1 })
vim.api.nvim_create_user_command('QuickFixDoReplace', ':cdo %s/<args>', { nargs = 1 })
vim.api.nvim_create_user_command('QuickFixUpdate', ':cdo update<bang>', {})

