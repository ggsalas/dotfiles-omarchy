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

            -- Unload theme plugin modules to force full reload
            if theme_plugin_name then
              local plugin = require("lazy.core.config").plugins[theme_plugin_name]

              if not plugin or not plugin._installed then
                vim.api.nvim_echo({
                  { "Installing theme plugin '" .. theme_plugin_name .. "'...", "WarningMsg" },
                }, false, {})
                require("lazy.manage").install({
                  plugins = { theme_plugin_name },
                  show = false, -- silent install without UI
                  wait = true, -- wait for installation to complete
                })
                vim.api.nvim_echo({}, false, {})
              end

              if plugin then
                -- Unload all lua modules from the plugin directory
                local plugin_dir = plugin.dir .. "/lua"
                require("lazy.core.util").walkmods(plugin_dir, function(modname)
                  package.loaded[modname] = nil
                  package.preload[modname] = nil
                end)
              end
            end

            -- Load the colorscheme plugin before executing config
            local colorscheme = theme_plugin_name and theme_plugin_name:gsub("%.nvim$", "") or nil
            if colorscheme then
              require("lazy.core.loader").colorscheme(colorscheme)
            end

            -- Execute the theme's config function (which sets background, runs setup, and applies colorscheme)
            if theme_spec.config and type(theme_spec.config) == "function" then
              -- Call config with proper parameters: (plugin_spec, opts_table)
              local plugin_opts = theme_spec.opts or {}
              theme_spec.config(theme_spec, plugin_opts)
            end

            -- Force redraw and reload transparency
            vim.defer_fn(function()
              vim.cmd("redraw!")
              -- Reload transparency settings if file exists
              if vim.fn.filereadable(transparency_file) == 1 then
                vim.defer_fn(function()
                  vim.cmd.source(transparency_file)
                  -- Final redraw
                  vim.cmd("redraw!")
                end, 5)
              end
            end, 5)
          end)
        end,
      })
    end,
  },
}
