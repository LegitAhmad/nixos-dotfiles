{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Define your hostname.
  networking.hostName = lib.mkDefault "nixos-btw";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager = {
    enable = true;
    # Periodic connectivity check to detect captive portals
    settings.connectivity = {
      uri = "http://nmcheck.gnome.org/check_network_status.txt";
      interval = 30;
      response = "NetworkManager is online";
    };
  };
  # Disable IPv6 to prevent unreachable route failures on networks without WAN IPv6.
  networking.enableIPv6 = false;

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Set your locale.
  i18n.defaultLocale = "en_US.UTF-8";

  # Cloudflare Warp daemon
  services.cloudflare-warp.enable = true;

  # Enable Avahi for network service discovery (Chromecast, Miracast MICE sinks)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Open firewall ports for Lan Mouse (software KVM switch) and GNOME Network Displays (Miracast RTSP)
  networking.firewall = {
    allowedTCPPorts = [
      4242
      7236
    ];
    allowedUDPPorts = [
      4242
      7236
    ];
  };

  # Automatically launch browser when a captive portal is detected
  systemd.user.services.captive-portal = {
    description = "Open browser when a captive portal is detected";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    path = [
      pkgs.networkmanager
      pkgs.xdg-utils
    ];
    script = ''
      # Check current connectivity immediately on startup in case already behind a portal
      if [ "$(nmcli networking connectivity)" = "portal" ]; then
        xdg-open "http://nmcheck.gnome.org/check_network_status.txt"
      fi

      nmcli monitor | while read -r line; do
        case "$line" in
          *"Connectivity is now 'portal'"*)
            xdg-open "http://nmcheck.gnome.org/check_network_status.txt"
            ;;
        esac
      done
    '';
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "3s";
    };
  };
}
