-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
--config.initial_cols = 120
--config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font = wezterm.font("UbuntuMono Nerd Font")
config.font_size = 12
config.color_scheme = "tokyonight"

config.window_padding = {
	left = 0,
	right = 2,
	top = 0,
	bottom = 0,
}

--config.line_height = 0.9

config.hide_tab_bar_if_only_one_tab = true

-- shift-enter for Claude
config.keys = {
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

-- Finally, return the configuration to wezterm:
return config
