local wezterm = require 'wezterm'

return {
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 12.5,

  color_scheme = "Catppuccin Mocha",

  -- Always start directly in your WSL Ubuntu
  default_domain = "WSL:Ubuntu-24.04",

  -- Avoid IME weirdness that can mess with key handling
  use_ime = false,

  -- Key mappings
  keys = {
    -- Fix Enter sending ^M: force it to send a plain LF ("\n")
    { key = "Enter", mods = "NONE", action = wezterm.action.SendString("\n") },

    -- Clipboard shortcuts
    { key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
  },
}