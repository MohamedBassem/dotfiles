-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Color Scheme
config.color_scheme = "Catppuccin Frappe"

-- Font
config.font = wezterm.font("MesloLGL Nerd Font")
config.font_size = 14.0

-- Disable tab bar (assuming the use of aerospace)
config.enable_tab_bar = false

-- Hide window decorations (only useful when using aerospace)
config.window_decorations = "RESIZE"

-- Increase scrollback lines
config.scrollback_lines = 1000000
config.enable_scroll_bar = true

-- Prompt before closing window
config.window_close_confirmation = "AlwaysPrompt"

config.keys = {
  -- Disable creating new tabs
  {
    key = "t",
    mods = "SUPER",
    action = wezterm.action.DisableDefaultAssignment,
  },

  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
  -- Make Option-Right equivalent to Alt-f; forward-word
  {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},
}

return config
