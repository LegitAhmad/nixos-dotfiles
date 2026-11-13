{
  config,
  pkgs,
  repoDir,
  ...
}:

{
  # Niri starts xwayland-satellite on demand; no second XWayland service.
  # Script wrappers put the repo scripts on PATH so config.kdl keybinds can
  # spawn them by name instead of hardcoding /home/<user> paths; the scripts
  # themselves stay hot-reloadable in the working tree.
  home.packages = [
    pkgs.xwayland-satellite
    (pkgs.writeShellScriptBin "autokey-toggle" ''
      exec "${repoDir}/scripts/autokey-toggle.py" "$@"
    '')
    (pkgs.writeShellScriptBin "niri-focus-occupied-workspace" ''
      exec "${repoDir}/scripts/niri-focus-occupied-workspace.py" "$@"
    '')
  ];

  xdg.configFile."niri/config.kdl" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/niri/config.kdl";
    force = true;
  };
}
