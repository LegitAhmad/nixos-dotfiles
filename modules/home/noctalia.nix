{
  config,
  pkgs,
  inputs,
  repoDir,
  ...
}:

let
  noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in

{
  home.packages = [ noctaliaPkg ];

  # Each compositor starts Noctalia itself: Hyprland in autostart.lua,
  # Niri in config.kdl. Do not also enable a shared shell user service.

  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/noctalia/config.toml";
    force = true;
  };
}
