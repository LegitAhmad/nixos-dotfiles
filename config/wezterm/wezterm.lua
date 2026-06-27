local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Add the user's config directory to the Lua path so require 'colors' works with symlinked wezterm.lua
local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/.config/wezterm/?.lua"

local colors = require 'colors'
colors.tab_bar = {
  background = colors.background,
  active_tab = {
    bg_color = colors.background,
    fg_color = colors.foreground,
    intensity = 'Bold',
  },
  inactive_tab = {
    bg_color = colors.background,
    fg_color = '#7f9687',
  },
  inactive_tab_hover = {
    bg_color = colors.background,
    fg_color = colors.foreground,
  },
  new_tab = {
    bg_color = colors.background,
    fg_color = '#7f9687',
  },
  new_tab_hover = {
    bg_color = colors.background,
    fg_color = '#cacd59',
  },
}
config.colors = colors
config.check_for_updates = false

-- Performance & Integration Optimizations
config.scrollback_lines = 10000                     -- Increase scrollback history
config.enable_kitty_graphics = true                 -- Enable Kitty graphics protocol (for yazi image previews)
config.adjust_window_size_when_changing_font_size = false -- Do not resize window on font zoom

config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'FiraCode Nerd Font',
  'Noto Color Emoji',
}

config.font_size = 13.0
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
config.use_fancy_tab_bar = true
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

-- Helper function to map processes to Cool icons
local function get_process_icon(process_name)
  local name = process_name:lower()
  if name:find("node") or name:find("npm") or name:find("yarn") then
    return "󰎙"
  elseif name:find("python") or name:find("py") then
    return "󰌠"
  elseif name:find("git") or name:find("lazygit") then
    return "󰊢"
  elseif name:find("nvim") or name:find("vim") or name:find("vi") then
    return ""
  elseif name:find("fish") or name:find("bash") or name:find("zsh") or name:find("sh") then
    return ""
  elseif name:find("cargo") or name:find("rustc") then
    return ""
  elseif name:find("docker") then
    return "󰡨"
  elseif name:find("yazi") then
    return "󰇘"
  elseif name:find("helix") or name:find("hx") then
    return "󰘦"
  else
    return ""
  end
end

-- Custom right status display with styled status pills (Workspace)
wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()
  
  local active_bg = '#364b3f'
  local active_fg = colors.foreground
  local inactive_bg = colors.background

  window:set_right_status(wezterm.format {
    -- Workspace Pill
    { Background = { Color = inactive_bg } },
    { Foreground = { Color = active_bg } },
    { Text = '' },
    { Background = { Color = active_bg } },
    { Foreground = { Color = active_fg } },
    { Text = '󱂬  ' .. workspace },
    { Background = { Color = inactive_bg } },
    { Foreground = { Color = active_bg } },
    { Text = ' ' },
  })
end)

-- Custom tab bar titles formatting (modern index + process/folder names with icons + rounded dividers + wide tabs)
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local index = tab.tab_index + 1
  local process_name = tab.active_pane.user_vars.WEZTERM_PROG or tab.active_pane.foreground_process_name or ""
  if process_name == "" then
    process_name = tab.active_pane.title
  end
  local title = tab.active_pane.title
  
  -- Shorten paths to just the current directory name
  if title:find("/") then
    title = title:gsub(".*/", "")
  end
  
  local icon = get_process_icon(process_name)
  
  local active_bg = '#364b3f'
  local active_fg = colors.foreground
  local inactive_bg = colors.background
  local inactive_fg = '#7f9687'
  local hover_bg = '#25352c'
  local hover_fg = colors.foreground

  if tab.is_active then
    return {
      { Background = { Color = inactive_bg } },
      { Foreground = { Color = active_bg } },
      { Text = '' },
      { Background = { Color = active_bg } },
      { Foreground = { Color = active_fg } },
      { Text = string.format("    %s  %d: %s    ", icon, index, title) },
      { Background = { Color = inactive_bg } },
      { Foreground = { Color = active_bg } },
      { Text = '' },
    }
  elseif hover then
    return {
      { Background = { Color = inactive_bg } },
      { Foreground = { Color = hover_bg } },
      { Text = '' },
      { Background = { Color = hover_bg } },
      { Foreground = { Color = hover_fg } },
      { Text = string.format("    %s  %d: %s    ", icon, index, title) },
      { Background = { Color = inactive_bg } },
      { Foreground = { Color = hover_bg } },
      { Text = '' },
    }
  else
    return {
      { Background = { Color = inactive_bg } },
      { Foreground = { Color = inactive_fg } },
      { Text = string.format("      %s  %d: %s      ", icon, index, title) },
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
