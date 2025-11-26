return {
  {
    name = "theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyReload",
        callback = function()
          -- Unload the theme spec module
          package.loaded["plugins.theme"] = nil -- Adjust path if your theme file is e.g. "plugins/bamboo"

          vim.schedule(function()
            local ok, theme_spec = pcall(require, "plugins.theme")
            if not ok then
              return
            end

            -- Find the theme plugin name (e.g., "bamboo.nvim")
            local theme_plugin_name = nil
            if theme_spec[1] then -- Assuming single spec or first one is the theme
              theme_plugin_name = theme_spec.name or theme_spec[1]:match("[^/]+$")
            end

            -- Clear all highlight groups before applying new theme
            vim.cmd("highlight clear")
            if vim.fn.exists("syntax_on") then
              vim.cmd("syntax reset")
            end

            -- Reset background to default so colorscheme can set it properly (light themes will set to light)
            -- Special handling for known light themes
            local theme_name = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":t")
            if theme_name == "catppuccin-latte" or theme_name:match("light") then
              vim.o.background = "light"
            else
              vim.o.background = "dark"
            end

            -- Unload theme plugin modules to force full reload
            if theme_plugin_name then
              local plugin = require("lazy.core.config").plugins[theme_plugin_name]
              if plugin then
                -- Unload all lua modules from the plugin directory
                local plugin_dir = plugin.dir .. "/lua"
                require("lazy.core.util").walkmods(plugin_dir, function(modname)
                  package.loaded[modname] = nil
                  package.preload[modname] = nil
                end)
              end
            end

            -- Derive colorscheme name (e.g., "bamboo" from "bamboo.nvim")
            --
            local colorscheme = theme_plugin_name and theme_plugin_name:gsub("%.nvim$", "") or nil
            if colorscheme then
              -- Load the colorscheme plugin
              require("lazy.core.loader").colorscheme(colorscheme)
              vim.defer_fn(function()
                -- Apply the colorscheme (it will set background itself)
                pcall(vim.cmd.colorscheme, colorscheme)
                -- Force redraw to update all UI elements
                vim.cmd("redraw!")
                -- Reload transparency settings if file exists
                if vim.fn.filereadable(transparency_file) == 1 then
                  vim.defer_fn(function()
                    vim.cmd.source(transparency_file)
                    -- Trigger UI updates for various plugins
                    vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
                    vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })
                    -- Final redraw
                    vim.cmd("redraw!")
                  end, 5)
                end
              end, 5)
            end
          end)
        end,
      })
    end,
  },
}
