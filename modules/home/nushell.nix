{ config, lib, pkgs, ... }:

let
  colors = config.lib.stylix.colors;
in
{
  programs.nushell = {
    enable = true;

    extraConfig = ''
      $env.config = {
        show_banner: false
        
        # Stylix Base16 color palette mapping for Nushell syntax and tables
        color_config: {
          separator: "#${colors.base03}"
          leading_alphabetic_title_color: { fg: "#${colors.base0D}" attr: b }
          header: { fg: "#${colors.base0B}" attr: b }
          empty: "#${colors.base0D}"
          bool: "#${colors.base09}"
          int: "#${colors.base0B}"
          filesize: "#${colors.base0C}"
          duration: "#${colors.base0A}"
          date: "#${colors.base0E}"
          range: "#${colors.base08}"
          float: "#${colors.base0B}"
          string: "#${colors.base05}"
          nothing: "#${colors.base03}"
          binary: "#${colors.base09}"
          cellpath: "#${colors.base05}"
          row_index: { fg: "#${colors.base04}" attr: b }
          record: "#${colors.base05}"
          list: "#${colors.base05}"
          block: "#${colors.base05}"
          hints: "#${colors.base03}"
          search_result: { fg: "#${colors.base00}" bg: "#${colors.base0A}" }
          shape_and: "#${colors.base0E}"
          shape_binary: "#${colors.base09}"
          shape_block: { fg: "#${colors.base0D}" attr: b }
          shape_bool: "#${colors.base09}"
          shape_custom: "#${colors.base0B}"
          shape_datetime: "#${colors.base0E}"
          shape_directory: "#${colors.base0D}"
          shape_external: "#${colors.base0C}"
          shape_externalarg: { fg: "#${colors.base0B}" attr: b }
          shape_filepath: "#${colors.base0D}"
          shape_flag: { fg: "#${colors.base0D}" attr: b }
          shape_float: "#${colors.base0B}"
          shape_garbage: { fg: "#${colors.base05}" bg: "#${colors.base08}" attr: b }
          shape_globpattern: "#${colors.base0D}"
          shape_int: "#${colors.base0B}"
          shape_internalcall: { fg: "#${colors.base0C}" attr: b }
          shape_list: "#${colors.base0D}"
          shape_literal: "#${colors.base0D}"
          shape_match_pattern: "#${colors.base0B}"
          shape_matching_brackets: { attr: u }
          shape_nothing: "#${colors.base03}"
          shape_operator: "#${colors.base0A}"
          shape_or: "#${colors.base0E}"
          shape_pipe: "#${colors.base0E}"
          shape_range: "#${colors.base0A}"
          shape_record: "#${colors.base0D}"
          shape_redirection: "#${colors.base0E}"
          shape_signature: { fg: "#${colors.base0B}" attr: b }
          shape_string: "#${colors.base05}"
          shape_string_interpolation: "#${colors.base0E}"
          shape_table: { fg: "#${colors.base0D}" attr: b }
          shape_variable: "#${colors.base0E}"
        }
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
  xdg.configFile."nushell/custom-config.nu".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/nushell/config.nu";
  xdg.configFile."nushell/custom-env.nu".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/nushell/env.nu";

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
