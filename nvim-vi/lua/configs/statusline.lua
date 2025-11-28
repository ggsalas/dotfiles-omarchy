-- Custom statusline without external plugins
-- Get LSP status function
function vim.g.get_lsp_status()
  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })

  if #buf_clients == 0 then
    return " "
  end

  -- Get diagnostics count
  local diagnostics = vim.diagnostic.get(0)
  local errors = 0
  local warnings = 0
  local info = 0
  local hints = 0

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      warnings = warnings + 1
    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
      info = info + 1
    elseif diagnostic.severity == vim.diagnostic.severity.HINT then
      hints = hints + 1
    end
  end

  -- Build status string
  local status_parts = {}

  if errors > 0 then
    table.insert(status_parts, errors .. " 󱎘 ")
  end
  -- For now only show the errors
  -- if warnings > 0 then
  --   table.insert(status_parts, warnings ..  " ")
  -- end
  -- if info > 0 then
  --   table.insert(status_parts, info .. "󰙎 ")
  -- end
  -- if hints > 0 then
  --   table.insert(status_parts, hints .. "󰛨 ")
  -- end

  -- Return diagnostic status only
  if #status_parts > 0 then
    return " " .. table.concat(status_parts, " ")
  else
    return "   "
  end
end

local file_and_modified = "%f %m"
local align_right = "%="
local status = "%{%g:get_lsp_status()%}"

vim.opt.statusline = file_and_modified .. align_right .. status

-- Auto-update statusline when diagnostics change
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.cmd("redrawstatus")
  end,
})
