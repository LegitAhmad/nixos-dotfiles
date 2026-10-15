{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  heliumExtensions = [
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    "dcjichoefijpinlfnjghokpkojhlhkgl" # Notifier for Gmail
    "ponfpcnoihfmfllpaingbgckeeldkhle" # Enhancer for YouTube
  ];
in
{
  xdg.configFile = lib.genAttrs (
    map (id: "net.imput.helium/External Extensions/${id}.json") heliumExtensions
  ) (_: {
    text = builtins.toJSON {
      # Helium resolves its built-in Web Store URL through its extension proxy.
      external_update_url = "https://update-url-to-be-replaced.qjz9zk";
    };
  });

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

  home.sessionVariables.BROWSER = "helium";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "helium.desktop" ];
      "application/xhtml+xml" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
    };
  };

  home.packages = with pkgs; [
    vesktop
    wl-clipboard
    satty
    hyprpicker
    nwg-look
    adw-gtk3
    proton-vpn
    mpv
    libreoffice-stable
    wpsoffice
    libnotify
    obs-studio
    spotify
    steam
    inputs.helium.packages.${system}.default
    inputs.zen-browser.packages.${system}.default
    inputs.omp.packages.${system}.omp
    inputs.llm-agents.packages.${system}.opencode
    inputs.llm-agents.packages.${system}.copilot-cli
    inputs.llm-agents.packages.${system}.cursor-agent
  ];

  gtk = {
    enable = lib.mkDefault true;
    theme = {
      name = lib.mkDefault "catppuccin-mocha-mauve-standard";
      package = lib.mkDefault (
        pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = [ "mauve" ];
        }
      );
    };
    iconTheme = {
      name = lib.mkDefault "Papirus-Dark";
      package = lib.mkDefault (
        pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "mauve";
        }
      );
    };
  };
}
