{
  config,
  lib,
  pkgs,
  repoDir,
  ...
}:

let
  kdeconnectPkg = pkgs.kdePackages.kdeconnect-kde;
in
{
  home.packages = [
    pkgs.lan-mouse
    kdeconnectPkg
    (pkgs.writeShellScriptBin "toggle-pc-sharing" ''
      exec "${repoDir}/scripts/toggle-pc-sharing.sh" "$@"
    '')
  ];

  # Lan Mouse configuration (out-of-store symlink)
  xdg.configFile."lan-mouse" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/lan-mouse";
    recursive = true;
  };

  # Prevent KDE Connect daemon from autostarting at login via XDG desktop autostart
  xdg.configFile."autostart/org.kde.kdeconnect.daemon.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=KDE Connect
    Exec=${kdeconnectPkg}/bin/kdeconnectd
    Hidden=true
  '';

  # Intercept KDE Connect D-Bus activation: delegate to systemd user service.
  # Because kdeconnect.service has RefuseManualStart=yes, D-Bus activation is
  # refused while pc-sharing.target is off, preventing silent restarts.
  xdg.dataFile."dbus-1/services/org.kde.kdeconnect.service".text = ''
    [D-BUS Service]
    Name=org.kde.kdeconnect
    Exec=${kdeconnectPkg}/bin/kdeconnectd
    SystemdService=kdeconnect.service
  '';

  # On-demand target that manages both Lan Mouse and KDE Connect together
  systemd.user.targets.pc-sharing = {
    Unit = {
      Description = "On-Demand PC Sharing (Lan Mouse & KDE Connect)";
      After = [ "graphical-session.target" ];
      Wants = [
        "lan-mouse.service"
        "kdeconnect.service"
      ];
    };
  };

  # Lan Mouse service (controlled exclusively via pc-sharing.target)
  systemd.user.services.lan-mouse = {
    Unit = {
      Description = "Lan Mouse - Software KVM switch daemon";
      Documentation = [ "https://github.com/feschber/lan-mouse" ];
      After = [ "graphical-session.target" ];
      PartOf = [ "pc-sharing.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.lan-mouse}/bin/lan-mouse daemon";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    Install = {
      WantedBy = lib.mkForce [ ];
    };
  };

  # Enable Home Manager KDE Connect service, but override it to be on-demand
  services.kdeconnect = {
    enable = true;
    indicator = false;
  };

  # Override kdeconnect.service:
  # - RefuseManualStart prevents direct start & D-Bus autoactivation while target is off
  # - PartOf binds its lifecycle to pc-sharing.target
  # - WantedBy is empty so it does NOT start at login
  systemd.user.services.kdeconnect = {
    Unit = {
      RefuseManualStart = true;
      PartOf = lib.mkForce [ "pc-sharing.target" ];
      After = lib.mkForce [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = lib.mkForce [ ];
    };
  };
}
