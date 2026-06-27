{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "ghbmnnjooekpmoecnnnilnnbdlolhkhi"; } # Google Docs Offline
      { id = "dcjichoefijpinlfnjghokpkojhlhkgl"; } # Notifier for Gmail (open-source alternative to Checker Plus)
    ];
  };

  programs.antigravity-cli = {
    enable = true;
  };

  services.network-manager-applet.enable = true;

  home.packages = with pkgs; [
    vesktop
    wl-clipboard
    grim
    slurp
    satty
    thunar
    nwg-look
    adw-gtk3
    proton-vpn
    mpv
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  gtk = {
    enable = lib.mkDefault true;
    theme = {
      name = lib.mkDefault "adw-gtk3-dark";
      package = lib.mkDefault pkgs.adw-gtk3;
    };
    iconTheme = {
      name = lib.mkDefault "Papirus-Dark";
      package = lib.mkDefault pkgs.papirus-icon-theme;
    };
  };
}
