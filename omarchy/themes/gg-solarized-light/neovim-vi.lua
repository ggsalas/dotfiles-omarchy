return {
  "maxmx03/solarized.nvim",
  name = "solarized",
  lazy = false,
  priority = 1000,
  opts = {
    on_highlights = function(colors, color)
      return {
        LineNr = { bg = "NONE" },
        CursorLine = { bg = colors.base2 },
        CursorLineNr = { bg = colors.base2 },
        SignColumn = { bg = "NONE" },
        -- GitSigns
        GitSignsAdd = { bg = "NONE" },
        GitSignsChange = { bg = "NONE" },
        GitSignsDelete = { bg = "NONE" },
        -- Diagnostics
        DiagnosticSignError = { bg = "NONE" },
        DiagnosticSignWarn = { bg = "NONE" },
        DiagnosticSignInfo = { bg = "NONE" },
        DiagnosticSignHint = { bg = "NONE" },
      }
    end,
  },
  config = function(_, opts)
    vim.o.background = "light" -- Set before setup for light mode

    require("solarized").setup(opts)
  end,
}
