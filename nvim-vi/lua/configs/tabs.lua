-- Simple tabs
vim.api.nvim_exec([[
function NewTabLine()
  let s = ''
  let t = tabpagenr()
  let i = 1
  while i <= tabpagenr('$')
    let buflist = tabpagebuflist(i)
    let winnr = tabpagewinnr(i)
    let s .= '%' . i . 'T'
    let s .= (i != 1 ? '%#TabLine#' : '')
    let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' '
    let  file = fnamemodify(
          \ bufname(tabpagebuflist(l:i)[tabpagewinnr(l:i) - 1]),
          \ ':t'
          \ )
    if file == ''
      let file = '[No Name]'
    endif
    let s .= file
    let s .= ' '
    let s .= (getbufvar(buflist[winnr - 1], "&mod") ? '+ ' : '')
    let i = i + 1
  endwhile
  let s .= '%T%#TabLineFill#%='
  let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
  return s
endfunction

set tabline=%!NewTabLine()
]], true)
