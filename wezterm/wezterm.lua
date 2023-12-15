local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- begin of custom config

-- Sync theme with OS
--
-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    --return 'Solarized (dark) (terminal.sexy)'
    return 'Catppuccin Macchiato'
  else
    return 'Catppuccin Latte'
    --return 'Atelier Cave Light (base16)'
    --return 'Gruvbox light, soft (base16)'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())
-- end

config.font_size = 15
config.font = wezterm.font {
  --family = 'BlexMono Nerd Font Mono',
  family = 'JetBrainsMono Nerd Font Mono',
}

config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font { family = 'JetBrainsMono', weight = 'Bold' },

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 15.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = '#333333',

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = '#333333',
}

config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#575757',
  },
}

-- Cleaner UI
config.enable_scroll_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 20000

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.window_background_opacity = 1
config.window_close_confirmation = "NeverPrompt"
-- disable titlebar (needed on macOS)
config.window_decorations = "RESIZE"

-- Do not hold on exit by default.
-- Because the default 'CloseOnCleanExit' can be annoying when exiting with
-- Ctrl-D and the last command exited with non-zero: the shell will exit
-- with non-zero and the terminal would hang until the window is closed manually.
config.exit_behavior = 'Close'

config.audible_bell = "Disabled"

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- default keybindings https://wezfurlong.org/wezterm/config/default-keys.html?h=def
config.keys = {
  {
    key = 't',
    mods = 'CMD|SHIFT',
    action = act.ShowTabNavigator,
  },
  {
    key = 'R',
    mods = 'CMD|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = ',',
    mods = 'CMD',
    action = act.SpawnCommandInNewTab {
      cwd = os.getenv('WEZTERM_CONFIG_DIR'),
      set_environment_variables = {
        TERM = 'screen-256color',
      },
      args = {
        'vim',
        os.getenv('WEZTERM_CONFIG_FILE'),
      },
    },
  },
  {
    key = 'k',
    mods = 'CMD',
    action = act.Multiple {
      -- act.SendKey { key = 'l', mods = 'CTRL' },
      act.ClearScrollback 'ScrollbackAndViewport',
    },
  },
  {
    key = 'Enter',
    mods = 'CMD',
    action = act.ToggleFullScreen,
  },
  {
    key="d",
    mods="CMD",
    action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}},
  },
  {
    key="d",
    mods = 'CMD|SHIFT',
    action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}},
  },
  {
    key="]",
    mods="CMD",
    action = act.ActivatePaneDirection 'Next',
  },
  {
    key="[",
    mods="CMD",
    action = act.ActivatePaneDirection 'Prev',
  },
}

return config

