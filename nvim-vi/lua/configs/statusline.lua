-- Custom statusline without external plugins
-- Get LSP status function
function vim.g.get_lsp_status()
  -- Check if current filetype has a linter configured
  local ft = vim.bo.filetype
  local has_lint = false

  -- Check if nvim-lint is loaded
  local lint_ok, lint = pcall(require, "lint")
  if lint_ok and lint.linters_by_ft then
    has_lint = lint.linters_by_ft[ft] ~= nil
  end

  -- If no linter is configured for this filetype, return empty string
  if not has_lint then
    return " "
  end

  -- Get diagnostics count
  local diagnostics = vim.diagnostic.get(0)
  local errors = 0

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    end
  end

  -- Return status string
  if errors > 0 then
    return " " .. errors .. " 󱎘 "
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
