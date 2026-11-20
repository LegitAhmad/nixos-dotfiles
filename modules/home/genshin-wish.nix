{
  pkgs,
  repoDir,
  ...
}:

{
  # Genshin wish-history helper: extracts the gacha authkey URL from the
  # game's webCaches (anime-games-launcher install), validates it against
  # the HoYo API, and exports pull history. Subcommands: url | fetch | check.
  # The Python source stays hot-reloadable in the working tree.
  home.packages = [
    (pkgs.writeShellScriptBin "genshin-wish" ''
      exec "${repoDir}/scripts/genshin-wish.py" "$@"
    '')
  ];
}
