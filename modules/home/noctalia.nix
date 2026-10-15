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

  # Plain Hyprland starts Noctalia in config/hypr/config/autostart.lua;
  # it does not activate graphical-session.target for systemd user services.

  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/noctalia/config.toml";
    force = true;
  };
}
