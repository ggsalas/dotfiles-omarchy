-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- ~/.config/hypr/bindings.lua
-- Migrated from bindings.conf (hyprlang) to the Omarchy 4 Lua syntax.
--
-- General migration notes:
--  * o.bind("MODS + KEY", "Description", command)   -> creates/replaces a bind
--  * hl.unbind("MODS + KEY")                        -> removes a default bind
--  * Modifiers are separated by " + " (required in Omarchy 4,
--    unlike hyprlang's "SUPER ALT, key").
--  * $terminal and $browser are no longer hyprlang variables; they are
--    resolved here as regular Lua variables.

-- local terminal = "uwsm app -- " .. (os.getenv("TERMINAL") or "alacritty")
local browser = "omarchy-launch-browser"

-- =====================================================================
-- Startup overrides
-- =====================================================================

-- o.bind(
--   "SUPER + ALT + RETURN",
--   "Tmux",
--   'uwsm-app -- xdg-terminal-exec --working-directory="$(omarchy-cmd-terminal-cwd)" tmux new'
-- )

-- macOS-style accent input (Alt+E) — requires wtype
o.bind("ALT + E", "Insert accent", "wtype -k Multi_key -k apostrophe")

-- macOS-style word-by-word cursor movement (Alt+arrows)
-- o.bind("ALT + RIGHT", "Word right (macOS-style)", hl.dsp.sendshortcut({ mods = "CTRL", key = "RIGHT" }))
-- o.bind("ALT + LEFT", "Word left (macOS-style)", hl.dsp.sendshortcut({ mods = "CTRL", key = "LEFT" }))

-- =====================================================================
-- Unbinds of Omarchy defaults that we replace or reorder
-- =====================================================================

hl.unbind("SUPER + O") -- Pop window out (float & pin) -> moved to SUPER + Y
hl.unbind("SUPER + J") -- Toggle window split -> now covered by SUPER + SLASH
hl.unbind("SUPER + L") -- Toggle workspace layout -> used for focus right instead
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
hl.unbind("SUPER + ALT + LEFT") -- Move window into group (l) -> moved to SUPER + CTRL + LEFT
hl.unbind("SUPER + ALT + RIGHT") -- Move window into group (r) -> moved to SUPER + CTRL + RIGHT
hl.unbind("SUPER + ALT + UP") -- Move window into group (u) -> moved to SUPER + CTRL + UP
hl.unbind("SUPER + ALT + DOWN") -- Move window into group (d) -> moved to SUPER + CTRL + DOWN
hl.unbind("SUPER + ALT + SPACE") -- Apps menu -> used for "next background" instead
hl.unbind("SUPER + CTRL + TAB") -- Former workspace (free, not used for now)
hl.unbind("SUPER + code:20") -- Expand window left -> resize with arrow keys instead
hl.unbind("SUPER + code:21") -- Shrink window left -> resize with arrow keys instead
hl.unbind("SUPER + ALT + code:20")
hl.unbind("SUPER + ALT + code:21")
hl.unbind("SUPER + CTRL + SPACE") -- free, used for the explicit Omarchy menu
hl.unbind("PRINT")
hl.unbind("ALT + PRINT")
hl.unbind("SUPER + PRINT")
hl.unbind("SUPER + ALT + TAB") -- Next window in group -> replaced by SUPER + O / I
hl.unbind("SUPER + SLASH") -- Monitor scaling up -> used for togglesplit instead
hl.unbind("SUPER + CTRL + LEFT") -- Move grouped window focus left -> moved to "move into group"
hl.unbind("SUPER + CTRL + RIGHT") -- Move grouped window focus right -> moved to "move into group"
hl.unbind("SUPER + P") -- Pseudo window (rarely used) -> left free, not reassigned

-- Conflicting default binds we override below (same key, different action)
hl.unbind("SUPER + SHIFT + C") -- Calendar (hey.com) -> replaced with Google Calendar
hl.unbind("SUPER + SHIFT + E") -- Email (hey.com) -> replaced with Gmail
hl.unbind("SUPER + SHIFT + G") -- Signal -> replaced with GoogleDrive
hl.unbind("SUPER + SHIFT + M") -- Music (Spotify) -> replaced with YouTube Music
hl.unbind("SUPER + SHIFT + N") -- Editor -> replaced with Simplenote
hl.unbind("SUPER + SHIFT + S") -- Google Maps -> replaced with Slack
hl.unbind("SUPER + CTRL + DELETE") -- Toggle laptop display -> replaced with Lock system

-- =====================================================================
-- Applications
-- =====================================================================

-- o.bind("SUPER + RETURN", "Terminal", terminal .. " --working-directory=$(omarchy-cmd-terminal-cwd)")
-- o.bind("SUPER + SHIFT + F", "File manager", "uwsm app -- nautilus --new-window")
-- o.bind("SUPER + SHIFT + B", "Browser", browser)
o.bind("SUPER + SHIFT + CTRL + B", "Browser (private)", browser .. " --private")
o.bind("SUPER + SHIFT + T", "System Activity", "omarchy-launch-tui btop")
o.bind("SUPER + SHIFT + R", "Docker", "omarchy-launch-tui lazydocker")

-- If your webapp URL contains #, write it as ## so Hyprland doesn't read it as a comment
o.bind("SUPER + SHIFT + C", "Calendar", 'omarchy-launch-or-focus-webapp Calendar "https://calendar.google.com"')
o.bind("SUPER + SHIFT + E", "Email", 'omarchy-launch-or-focus-webapp Email "https://mail.google.com"')
o.bind("SUPER + SHIFT + G", "GoogleDrive", 'omarchy-launch-webapp "https://drive.google.com"')
o.bind("SUPER + SHIFT + M", "Music", 'omarchy-launch-or-focus-webapp Music "https://music.youtube.com/"')
o.bind("SUPER + SHIFT + U", "WhatsApp", 'omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"')
o.bind("SUPER + SHIFT + N", "Simplenote", 'omarchy-launch-webapp "https://app.simplenote.com/"')
o.bind("SUPER + SHIFT + S", "Slack", "omarchy-launch-or-focus Slack ~/.config/bin/slack-dept.sh")

-- =====================================================================
-- Focus movement between windows (home row: H/J/K/L)
-- =====================================================================

o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))

-- Swap window (SUPER + CTRL + H/L/K/J) already comes as an Omarchy 4 default,
-- kept unchanged, no need to redefine it here.

-- Swap window with arrow keys: Omarchy 4 default, kept unchanged
-- (SUPER + SHIFT + LEFT/RIGHT/UP/DOWN is already defined by Omarchy)

-- =====================================================================
-- Resize the active window (arrow keys)
-- =====================================================================

o.bind("SUPER + LEFT", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + RIGHT", "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + UP", "Shrink window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + DOWN", "Expand window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

-- =====================================================================
-- Tiling
-- =====================================================================

o.bind("SUPER + SLASH", "Toggle window split", hl.dsp.layout("togglesplit"))

-- Move active window to a workspace with SUPER + SHIFT + CTRL + [0-9]
-- (SUPER + CTRL + [0-9] is NOT used here: it's the Omarchy default for the
-- bar panel shortcuts, so reusing it would fire both actions at once)
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + SHIFT + CTRL + " .. key)
  o.bind(
    "SUPER + SHIFT + CTRL + " .. key,
    "Move window to workspace " .. workspace,
    hl.dsp.window.move({ workspace = tostring(workspace) })
  )
end

-- =====================================================================
-- Other window / system actions
-- =====================================================================

o.bind("SUPER + CTRL + SPACE", "Omarchy menu", "omarchy-menu")
o.bind("SUPER + ALT + SPACE", "Next background in theme", "omarchy-theme-bg-next")
o.bind("SUPER + CTRL + DELETE", "Lock system", "omarchy-system-lock")

o.bind("CTRL + SHIFT + 4", "Screenshot of region", "omarchy-cmd-screenshot")
o.bind("CTRL + SHIFT + 5", "Screen record a region", "omarchy-cmd-screenrecord")
o.bind("CTRL + SHIFT + 1", "Color picker", "pkill hyprpicker || hyprpicker -a")
-- Note: with uwsm (as Omarchy uses), hl.dsp.exit() can leave the session in
-- an inconsistent state because it doesn't go through uwsm's ordered shutdown.
-- "uwsm stop" is used instead, as recommended by the Hyprland documentation.
o.bind("CTRL + ALT + BACKSPACE", "Restart Hyprland", "uwsm stop")

-- =====================================================================
-- Groups (SUPER + G)
-- =====================================================================

o.bind("SUPER + Y", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
o.bind("SUPER + U", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))

-- Join windows into a group
o.bind("SUPER + CTRL + LEFT", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + CTRL + RIGHT", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("SUPER + CTRL + UP", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + CTRL + DOWN", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

-- Navigate the same set of grouped windows
o.bind("SUPER + O", "Next window in group", hl.dsp.group.next())
o.bind("SUPER + I", "Previous window in group", hl.dsp.group.prev())
