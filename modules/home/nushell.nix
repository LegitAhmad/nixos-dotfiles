{
  config,
  lib,
  pkgs,
  repoDir,
  ...
}:

{
  programs.nushell = {
    enable = true;

    extraConfig = ''
      $env.config = {
        show_banner: false
        highlight_resolved_externals: true
      }

      # Source custom configurations from the dotfiles repository (out-of-store)
      source ~/.config/nushell/custom-config.nu
    '';

    extraEnv = ''
      # Source custom environment from the dotfiles repository (out-of-store)
      source ~/.config/nushell/custom-env.nu
    '';
  };

  # Out-of-store symlinks to the repository configuration files for hot-reloading
  xdg.configFile."nushell/custom-config.nu".source =
    config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/nushell/config.nu";
  xdg.configFile."nushell/custom-env.nu".source =
    config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/nushell/env.nu";

  # Generate fzf integration script at build/activation time to avoid parse-time subexpression evaluation in Nushell
  # We patch the optional member access chain to avoid a type-inference bug in Nushell where previous_external_completer is incorrectly inferred as a record.
  xdg.configFile."nushell/fzf.nu".source = pkgs.runCommand "fzf.nu" { buildInputs = [ pkgs.fzf ]; } ''
    fzf --nushell | sed 's|let previous_external_completer = .*|let previous_external_completer = ($env.CARAPACE_COMPLETER? \| default null)|' > $out
  '';

  # Carapace integration for Nushell
  programs.carapace.enableNushellIntegration = true;

  # Oh My Posh integration for Nushell
  programs.oh-my-posh.enableNushellIntegration = true;

  # Zoxide integration for Nushell
  programs.zoxide.enableNushellIntegration = true;
}
