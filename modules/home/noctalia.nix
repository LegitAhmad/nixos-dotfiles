{
  config,
  lib,
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

  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia - A lightweight Wayland shell and bar";
      Documentation = [ "https://docs.noctalia.dev/v5/" ];
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${noctaliaPkg}/bin/noctalia";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/noctalia/config.toml";
    force = true;
  };
}
