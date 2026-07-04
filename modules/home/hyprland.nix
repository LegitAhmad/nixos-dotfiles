{
  config,
  pkgs,
  repoDir,
  ...
}:

{
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/hypr";
    recursive = true;
  };
  home.packages = with pkgs; [
    hyprshutdown
  ];
}
