{
  config,
  lib,
  pkgs,
  inputs,
  repoDir,
  osConfig ? null,
  ...
}:

let
  officialPlugins = pkgs.fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "official-plugins";
    rev = "734850fd1ee3badc2a18a515df31f36267852e46";
    hash = "sha256-kYgPQYiQ3A8NS6S7E2wp2spwFEoXO+URJ4FVtDGp31o=";
  };
  initializeStorageKey = pkgs.writeShellScript "noctalia-storage-key" ''
    set -eu
    umask 077
    key_dir=${lib.escapeShellArg "${config.xdg.stateHome}/noctalia"}
    ${pkgs.coreutils}/bin/mkdir -p "$key_dir"
    if [ ! -e "$key_dir/storage-key" ]; then
      ${pkgs.openssl}/bin/openssl rand -hex 32 > "$key_dir/storage-key"
    fi
  '';
in

{
  home.packages = [
    # Keep the upstream derivation unchanged so noctalia.cachix.org can supply it.
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.bitwarden-cli
    pkgs.coreutils # sleep when restarting bw serve
    pkgs.curl # lock and sync requests, including shutdown locking
    pkgs.procps # pkill for plugin-owned bw serve teardown
  ];

  # Generate locally, never in the Nix store or through Secret Service.
  home.activation.noctaliaStorageKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${initializeStorageKey}
  '';

  # Native Luau plugin; local data plugins override downloaded catalog copies.
  # Activation and plugin settings remain in the hot-linked config.toml.
  xdg.dataFile."noctalia/plugins/bitwarden".source = "${officialPlugins}/bitwarden";

  # Each compositor starts Noctalia itself: Hyprland in autostart.lua,
  # Niri in config.kdl. Do not also enable a shared shell user service.

  xdg.configFile = {
    "noctalia/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/noctalia/config.toml";
      force = true;
    };
  } // lib.optionalAttrs (osConfig != null && osConfig.networking.hostName == "lennix") {
    "noctalia/host.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/noctalia/hosts/lennix.toml";
      force = true;
    };
  };
}
