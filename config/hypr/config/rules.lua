-- Browser rules: no blur, fully opaque
hl.window_rule({
	name = "chromium-noblur",
	match = { class = "chromium-browser" },
	no_blur = true,
	opaque = true,
})

-- Floating rules for dialogs and portals
hl.window_rule({
	name = "thunar-float",
	match = { class = "thunar" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "xdg-desktop-portal-float",
	match = { class = "xdg-desktop-portal-gtk" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "polkit-float",
	match = { class = "polkit-gnome-authentication-agent-1" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "blueman-float",
	match = { class = "blueman-manager" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "pavucontrol-float",
	match = { class = "pavucontrol" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "nm-float",
	match = { class = "nm-connection-editor" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "polkit-kde-float",
	match = { class = "org.kde.polkit-kde-authentication-agent-1" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "protonvpn-float",
	match = { class = "protonvpn-app" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "satty-float",
	match = { class = "com.gabm.satty" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "nwg-look-float",
	match = { class = "nwg-look" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

-- Picture-in-Picture: float and pin
hl.window_rule({
	name = "pip-float-pin",
	match = { title = "^Picture-in-Picture$" },
	float = true,
	pin = true,
})

hl.window_rule({
	name = "pip2-float-pin",
	match = { title = "^Picture in picture$" },
	float = true,
	pin = true,
})

-- Pop-up/dialog windows: float and move to top-left
hl.window_rule({
	name = "open-file-float",
	match = { title = "^Open File$" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "save-file-float",
	match = { title = "^Save File$" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	name = "file-upload-float",
	match = { title = "^File Upload$" },
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.5)",
	center = true,
})
