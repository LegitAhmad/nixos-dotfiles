{ pkgs, inputs }:

let
  inherit (pkgs) lib;

  # Packaged upstream in nixpkgs (pkgs/by-name); binary-fetched from
  # cache.nixos.org — nothing compiles locally. Catalog: https://getartcraft.com/apps
  # Upstream apps register MIME types; XDG defaults are wired in apps.nix.
  # Native Wayland file drag-and-drop is not supported by every app upstream.
  nixpkgsApps = [
    "photocraft"
    "vectorcraft"
    "filmcraft"
    "lightcraft"
    "soundcraft"
    "wordcraft"
    "pdfcraft"
    "deckcraft"
    "cadcraft"
    "gridcraft"
  ];

  # Not packaged in nixpkgs, and their official flakes build from source with
  # no binary cache. Fetch upstream's prebuilt Linux binaries instead; the
  # native tarballs include the GUI, CLI/MCP tools, desktop entries, icons and
  # MIME definitions. Release metadata is pinned in flake.lock; `nix flake
  # update <name>-release` refreshes versions and archive checksums.
  binApps = [
    "effectcraft"
    "designcraft"
    "figcraft"
  ];

  runtimeLibraries = with pkgs; [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    libGL
    dbus
    fontconfig
    freetype
  ];

  mkCraft =
    name:
    let
      release = builtins.fromJSON (builtins.readFile inputs."${name}-release");
      version = lib.removePrefix "v" release.tag_name;
      archiveName = "${name}-${version}-linux-x86_64.tar.gz";
      archive = lib.findFirst (
        asset: asset.name == archiveName
      ) (throw "${name}: release ${release.tag_name} has no ${archiveName}") release.assets;
      appLibraries = runtimeLibraries ++ lib.optionals (name == "effectcraft") [ pkgs.alsa-lib ];
    in
    pkgs.stdenv.mkDerivation {
      pname = name;
      inherit version;

      src = pkgs.fetchurl {
        url = archive.browser_download_url;
        sha256 = lib.removePrefix "sha256:" archive.digest;
      };

      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      buildInputs = appLibraries ++ [ pkgs.stdenv.cc.cc.lib ];
      # winit, wgpu and file dialogs load these with dlopen, not DT_NEEDED.
      runtimeDependencies = map lib.getLib appLibraries;
      dontBuild = true;
      dontStrip = true;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r bin share "$out/"
        runHook postInstall
      '';

      meta = {
        description = "${name} from the ArtCraft Crafting Apps suite";
        homepage = "https://getartcraft.com/apps/${name}";
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        license = lib.licenses.OR [
          lib.licenses.mit
          lib.licenses.asl20
        ];
        platforms = [ "x86_64-linux" ];
        mainProgram = name;
      };
    };
in
lib.genAttrs nixpkgsApps (name: pkgs.${name}) // lib.genAttrs binApps mkCraft
