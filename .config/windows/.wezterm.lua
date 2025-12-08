local wezterm = require("wezterm")

-- ---------- Helpers ----------

local function right_truncate_with_ellipsis(text, max_len)
	if max_len <= 0 then
		return ""
	end

	local len = #text
	if len <= max_len then
		return text
	end

	local keep = max_len - 1
	if keep <= 0 then
		return "…"
	end
	return "…" .. text:sub(len - keep + 1)
end

-- ---------- Startup position & size ----------

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	local gui = window:gui_window()

	gui:set_position(200, 80) -- X, Y in pixels
	gui:set_inner_size(1400, 900) -- Width, Height in pixels (content area)
end)

-- ---------- Right status: ----------

wezterm.on("update-right-status", function(window, pane)
	local date = wezterm.strftime("%Y-%m-%d %H:%M")

	window:set_right_status(wezterm.format({
		{ Text = "  " .. date .. "  " },
	}))
end)

-- ---------- Tab titles: ----------

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local cwd_uri = pane:get_current_working_dir()

	local cwd = ""
	if cwd_uri then
		local s = tostring(cwd_uri)
		s = s:gsub("^file://", "") -- strip file:// prefix
		cwd = s
	else
		cwd = pane.title or ""
	end

	local prefix = tab.is_active and "● " or "  "
	local raw_title = prefix .. cwd

	local HARD_MAX = 50
	local MIN_MAX = 20

	local allowed = max_width - 2
	if allowed < MIN_MAX then
		allowed = MIN_MAX
	end
	if allowed > HARD_MAX then
		allowed = HARD_MAX
	end

	local title = right_truncate_with_ellipsis(raw_title, allowed)

	return {
		{ Text = " " .. title .. " " },
	}
end)

-- ---------- Main config ----------

return {
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 12.5,
	color_scheme = "Catppuccin Mocha",
	default_domain = "WSL:Ubuntu-24.04",
	use_ime = false,
	window_background_opacity = 1,
	text_background_opacity = 0.92,

	window_padding = {
		left = 6,
		right = 6,
		top = 3,
		bottom = 3,
	},

	use_fancy_tab_bar = true,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = false,

	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.65,
	},
}
