local wezterm = require("wezterm")

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Config start

config.font = wezterm.font("JetBrainsMono Nerd Font")

config.font_size = 15

config.window_padding = {
	left = 0,
	right = 0,
	top = 5,
	bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true

config.check_for_updates = false

config.color_scheme = "Gruvbox dark, medium (base16)"

-- Config end

return config
