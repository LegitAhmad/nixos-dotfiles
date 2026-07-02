local constants = require("config.constants")

local mainMod = "SUPER"

hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(constants.terminal))
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(constants.browser))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(constants.explorer))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("hyprpicker -a"))

-- Scratchpad (Special Workspace)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Window resize (width)
-- Native window resizing with Vim keys (Hold down keys to repeat)
local resizeUnit = 50

hl.bind(
	mainMod .. " + SHIFT + H",
	hl.dsp.window.resize({ x = -resizeUnit, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + L",
	hl.dsp.window.resize({ x = resizeUnit, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + J",
	hl.dsp.window.resize({ x = 0, y = resizeUnit, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + K",
	hl.dsp.window.resize({ x = 0, y = -resizeUnit, relative = true }),
	{ repeating = true }
)

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + Z", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(), { mouse = true })

for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
	hl.bind(mainMod .. " + ALT + " .. i, hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end

-- Audio controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- Brightness controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

-- Noctalia lock
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))

-- Noctalia wallpaper panel
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"))

-- Noctalia notifications
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center notifications"))

-- Noctalia media controls
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("noctalia msg media next"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("noctalia msg media previous"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("noctalia msg media toggle"))

-- Noctalia window switcher
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher"))

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
