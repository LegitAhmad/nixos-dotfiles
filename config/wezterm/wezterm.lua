local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ==========================================
-- Appearance & Typography
-- ==========================================
-- Color Scheme: Catppuccin Mocha dark theme
config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium' })
config.font_size = 12.0
config.line_height = 1.15

-- Beautiful background opacity with no window title bars for a clean flat aesthetic
config.window_background_opacity = 0.85
config.window_decorations = 'NONE'
config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

-- Tab bar layout & styling
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false


-- ==========================================
-- Keybindings & Multiplexing
-- ==========================================
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

local act = wezterm.action
config.keys = {
  -- Split panes (Vim-style and standard tmux style)
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '|', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Switch panes (Alt + Vim key / Leader + Vim key)
  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },

  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },

  -- Adjust pane size (Leader + arrow keys)
  { key = 'LeftArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },

  -- Tabs creation & switching
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

  -- Workspaces (Leader + w or s to show workspace list, Leader + r to rename)
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
  { key = 'r', mods = 'LEADER', action = act.PromptInputLine {
    description = 'Rename current workspace',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
      end
    end),
  } },

  -- Copy Mode / Search Mode
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'f', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
}

-- Tab Navigation 1-9 (Leader + number)
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

-- Custom right status display for active workspace name
wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()
  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = 'Bold' } },
    { Foreground = { AnsiColor = 'Cyan' } },
    { Text = '   ' .. workspace .. '  ' },
  })
end)

return config
