{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  craftingApps = import ./crafting-apps { inherit pkgs inputs; };
  heliumExtensions = [
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    "dcjichoefijpinlfnjghokpkojhlhkgl" # Notifier for Gmail
    "ponfpcnoihfmfllpaingbgckeeldkhle" # Enhancer for YouTube
  ];
  googleSearchTemplate = {
    alternate_urls = [ ];
    contextual_search_url = "";
    created_from_play_api = false;
    date_created = "0";
    doodle_url = "";
    enforced_by_policy = false;
    favicon_url = "https://www.gstatic.com/images/branding/searchlogo/ico/favicon.ico";
    featured_by_policy = false;
    id = "8";
    image_search_branding_label = "";
    image_translate_source_language_param_key = "";
    image_translate_target_language_param_key = "";
    image_translate_url = "";
    image_url = "https://lens.google.com/upload";
    image_url_post_params = "encoded_image={google:imageThumbnail}";
    input_encodings = [ "UTF-8" ];
    is_active = 0;
    keyword = "google.com";
    last_modified = "13437518791831905";
    last_visited = "13437557656498685";
    logo_url = "";
    new_tab_url = "";
    originating_url = "";
    policy_origin = 0;
    preconnect_to_search_url = false;
    prefetch_likely_navigations = false;
    prepopulate_id = 1;
    safe_for_autoreplace = true;
    search_intent_params = [ ];
    search_url_post_params = "";
    send_x_geo_header = false;
    short_name = "Google";
    starter_pack_id = 0;
    suggestions_url = "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
    suggestions_url_post_params = "";
    synced_guid = "485bf7d3-0215-45af-87dc-538868000001";
    url = "https://www.google.com/search?q={searchTerms}";
    usage_count = 0;
  };
  # Seed new profiles and reapply preferences on activation or the next launch.
  heliumPreferences = {
    default_search_provider = {
      guid = "485bf7d3-0215-45af-87dc-538868000001";
    };
    default_search_provider_data = {
      template_url_data = googleSearchTemplate;
      mirrored_template_url_data = googleSearchTemplate;
    };
    session.restore_on_startup = 1; # Continue where you left off.
    download.prompt_for_download = true; # Ask where to save each download.
    browser = {
      show_forward_button = true;
      show_home_button = false;
      pin_split_tab_button = true;
    };
    toolbar.pinned_actions = [ ]; # Remove other pinned toolbar actions.
    helium = {
      completed_onboarding = true;
      services = {
        user_consented = true;
        schema_version = 1;
      };
      browser = {
        layout = 2; # Vertical tabs.
        vertical_right_aligned = true; # Keep the vertical tab sidebar on the right.
        centered_location_bar = true;
        minimal_location_bar = true; # Show the site origin until the URL is focused.
        show_back_button = true;
        show_reload_button = true;
        # Keep only Extensions, media controls, and the menu on the right.
        show_extensions_button = true;
        show_media_button = true;
        show_menu_button = true;
        show_avatar_button = false;
        show_vertical_tabs_collapse_button = false; # Alt+S still toggles the sidebar.
        show_dynamic_new_tab_button = false;
        # IDC_CTRL_S_SHORTCUT: replace Ctrl+S rather than adding a second toggle.
        custom_accelerators."34090" = {
          added = [ "Alt+KeyS" ];
          removed = [ "Control+KeyS" ];
        };
      };
      settings.behavior.vertical_collapse_shortcut = true;
    };
  };
  heliumInitialPreferences = pkgs.writeText "helium-initial-preferences.json" (
    builtins.toJSON heliumPreferences
  );
  heliumPackage = inputs.helium.packages.${system}.default.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cp ${heliumInitialPreferences} "$out/opt/helium/initial_preferences"
      # Prevent WebRTC calls from adjusting the system microphone input volume.
      wrapProgram "$out/bin/helium" \
        --add-flags "--disable-features=WebRtcAllowInputVolumeAdjustment" \
        --run '${configureHelium} "$@"'
    '';
  });
  configureHelium = pkgs.writeShellScript "configure-helium-preferences" ''
    set -eu
    umask 077
    user_data=${lib.escapeShellArg "${config.xdg.configHome}/net.imput.helium"}
    # Respect isolated/custom profiles when invoked through the browser launcher.
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --user-data-dir=*) user_data="''${1#*=}" ;;
        --user-data-dir)
          [ "$#" -ge 2 ] || break
          user_data="$2"
          shift
          ;;
        --) break ;;
      esac
      shift
    done
    # Never race Helium's in-memory preferences or replace its writable profile.
    if [ -e "$user_data/SingletonLock" ] || [ -L "$user_data/SingletonLock" ]; then
      echo "Helium is running; deferring profile preferences until its next launch." >&2
      exit 0
    fi
    ${pkgs.coreutils}/bin/mkdir -p "$user_data/Default"
    for profile in "$user_data/Default" "$user_data"/Profile\ *; do
      [ -d "$profile" ] || continue
      preferences="$profile/Preferences"
      source="$preferences"
      [ -f "$source" ] || source=${pkgs.writeText "empty-helium-preferences.json" "{}"}
      temporary=$(${pkgs.coreutils}/bin/mktemp "$profile/.Preferences.XXXXXX")
      trap '${pkgs.coreutils}/bin/rm -f "$temporary"' EXIT
      ${pkgs.jq}/bin/jq --slurpfile defaults ${heliumInitialPreferences} \
        '. * $defaults[0]' "$source" > "$temporary"
      ${pkgs.coreutils}/bin/mv "$temporary" "$preferences"
      trap - EXIT
    done
  '';
in
{
  xdg.configFile =
    lib.genAttrs (map (id: "net.imput.helium/External Extensions/${id}.json") heliumExtensions)
      (_: {
        text = builtins.toJSON {
          # Helium resolves its built-in Web Store URL through its extension proxy.
          external_update_url = "https://update-url-to-be-replaced.qjz9zk";
        };
      });

  # An open browser defers the update to its next launch, never failing activation.
  home.activation.heliumPreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${configureHelium}
  '';

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

  # The complete native Crafting Apps suite, including each app's CLI/MCP tools.
  home.packages =
    lib.attrValues craftingApps
    ++ (with pkgs; [
      discord
      vesktop
      wl-clipboard
      satty
      hyprpicker
      nwg-look
      adw-gtk3
      proton-vpn
      mpv
      onlyoffice-desktopeditors
      wpsoffice
      libnotify
      obs-studio
      spotify
      brave-origin
      lunar-client
      osu-lazer-bin
      file-roller
      heliumPackage
      inputs.zen-browser.packages.${system}.default
      inputs.llm-agents.packages.${system}.omp
      inputs.llm-agents.packages.${system}.opencode
      inputs.llm-agents.packages.${system}.copilot-cli
      inputs.llm-agents.packages.${system}.cursor-agent
      inputs.llm-agents.packages.${system}.codex
      inputs.llm-agents.packages.${system}.claude-code
      inputs.llm-agents.packages.${system}.chatgpt # Official Linux desktop app.
      inputs.serena.packages.${system}.default # Serena CLI and MCP server toolkit.
    ]);

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
