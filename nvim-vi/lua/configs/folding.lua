vim.cmd [[
function! GGsalasFoldStyle()
    let line = getline(v:foldstart)

    let nucolwidth = &foldcolumn + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart . ' lines  '

    " expand tabs into spaces
    let chunks = split(line, "\t", 1)
    let line = join(map(chunks[:-2], 'v:val . repeat(" ", &tabstop - strwidth(v:val) % &tabstop)'), '') . chunks[-1]

    let line = strpart(line, 0, windowwidth - 2 - len(foldedlinecount)) . ' '
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)

    return line . repeat('.', fillcharcount) . ' ' . foldedlinecount
endfunction
]]

vim.api.nvim_create_user_command('FoldSyntax', function()
  vim.opt.foldmethod = 'syntax'
  vim.opt.foldlevel = 0
end, {})

vim.api.nvim_create_user_command('FoldExpr', function()
  vim.opt.foldmethod = 'expr'
  vim.opt.foldlevel = 0
end, {})

vim.api.nvim_create_user_command('FoldManual', function()
  vim.opt.foldmethod = 'manual'
  vim.opt.foldlevel = 0
end, {})

vim.api.nvim_create_user_command('FoldDiff', function()
  vim.opt.foldmethod = 'diff'
  vim.opt.foldlevel = 0
end, {})

-- SEEMS I'M NOT USING DIFFERENT CONFIGS PER FILE TYPE
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldtext = 'GGsalasFoldStyle()'
vim.opt.foldlevel = 99
