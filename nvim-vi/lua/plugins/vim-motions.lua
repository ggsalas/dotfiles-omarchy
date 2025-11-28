return {
  -- better vim motions
  ---------------------
  "ggandor/leap.nvim",
  config = function()
    local leap = require("leap")

    leap.opts.labels = "jhkl;fgdsauyiopmn,./rtewqvbcxz"

    vim.keymap.set("n", "f", "<Plug>(leap-forward)")
    vim.keymap.set("n", "t", "<Plug>(leap-forward-till)")
    vim.keymap.set("n", "F", "<Plug>(leap-backward)")
    vim.keymap.set("n", "T", "<Plug>(leap-backward-till)")

    vim.keymap.set("n", "gf", function()
      require("leap").leap({ target_windows = { vim.api.nvim_get_current_win() } })
    end)
  end,
}
