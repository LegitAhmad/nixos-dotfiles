hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd(
		"bash -c 'eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh) && dbus-update-activation-environment --systemd --all && systemctl --user import-environment SSH_AUTH_SOCK && systemctl --user start nixos-fake-graphical-session.target'"
	)
end)
