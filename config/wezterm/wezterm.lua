local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Add the user's config directory to the Lua path so require 'colors' works with symlinked wezterm.lua
local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/.config/wezterm/?.lua"

local colors = require 'colors'
colors.tab_bar = {
  background = colors.background,
  active_tab = {
    bg_color = '#364b3f',
    fg_color = colors.foreground,
    intensity = 'Bold',
  },
  inactive_tab = {
    bg_color = colors.background,
    fg_color = '#7f9687',
  },
  inactive_tab_hover = {
    bg_color = '#25352c',
    fg_color = colors.foreground,
  },
  new_tab = {
    bg_color = colors.background,
    fg_color = '#7f9687',
  },
  new_tab_hover = {
    bg_color = '#25352c',
    fg_color = '#cacd59',
  },
}
config.colors = colors

config.font = wezterm.font_with_fallback {
  'FantasqueSansM Nerd Font',
  'FiraCode Nerd Font',
  'JetBrainsMono Nerd Font Mono',
}
config.font_size = 15.0
config.line_height = 1.15

-- Set cursor to blinking bar (not block)
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

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
config.hide_tab_bar_if_only_one_tab = false
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

-- Custom right status display for active workspace name and date/time (Tmux-like style)
wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()
  local date = wezterm.strftime('%a %b %d  %I:%M %p')
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#7f9687' } },
    { Text = '   ' .. workspace .. ' ' },
    { Foreground = { Color = '#364b3f' } },
    { Text = ' │ ' },
    { Foreground = { Color = '#90d5ae' } },
    { Text = '   ' .. date .. ' ' },
  })
end)

-- Custom tab bar titles formatting (modern index + process/folder names with icons)
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local index = tab.tab_index + 1
  local title = tab.active_pane.title
  
  -- Shorten paths to just the current directory name
  if title:find("/") then
    title = title:gsub(".*/", "")
  end
  
  local icon = ""
  if tab.is_active then
    return {
      { Attribute = { Intensity = 'Bold' } },
      { Text = string.format(" %s %d: %s ", icon, index, title) }
    }
  else
    return {
      { Text = string.format(" %d: %s ", index, title) }
    }
  end
end)

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local selection = window:get_selection_text_for_pane(pane)
      if selection and selection ~= "" then
        window:perform_action(wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection', pane)
        local display = selection
        if #display > 30 then
          display = display:sub(1, 30) .. "..."
        end
        display = display:gsub("\n", " ")
        window:toast_notification("WezTerm", "Copied: \"" .. display .. "\"", nil, 1500)
      else
        window:perform_action(wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection', pane)
      end
    end),
  },
}

return config
