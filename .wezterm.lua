local wezterm = require("wezterm")

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Config start

config.font = wezterm.font("JetBrainsMono Nerd Font")

config.font_size = 16

config.window_padding = {
	left = 4,
	right = 4,
	top = 20,
	bottom = 4,
}

config.hide_tab_bar_if_only_one_tab = true

config.check_for_updates = false

config.color_scheme = "Gruvbox dark, medium (base16)"

config.window_background_opacity = 1.0

config.window_decorations = "RESIZE"

-- Config end

return config
