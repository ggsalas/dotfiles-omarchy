-- Simple tabs
function NewTabLine()
  local s = ""
  local current_tab = vim.fn.tabpagenr()
  local tab_count = vim.fn.tabpagenr("$")

  for i = 1, tab_count do
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)

    s = s .. "%" .. i .. "T"
    if i ~= 1 then
      s = s .. "%#TabLine#"
    end
    s = s .. (i == current_tab and "%#TabLineSel#" or "%#TabLine#")
    s = s .. " "

    local file = vim.fn.fnamemodify(vim.fn.bufname(buflist[winnr]), ":t")
    if file == "" then
      file = "No Name"
    end

    s = s .. "[" .. i .. "] " .. file .. " "

    if vim.fn.getbufvar(buflist[winnr], "&mod") == 1 then
      s = s .. "+ "
    end
  end

  s = s .. "%T%#TabLineFill#%="
  s = s .. (tab_count > 1 and "%999XX" or "X")
  return s
end

vim.o.tabline = "%!v:lua.NewTabLine()"
