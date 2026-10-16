{ pkgs, inputs }:

let
  inherit (pkgs) lib;
  releases = lib.genAttrs [
    "photocraft"
    "vectorcraft"
    "filmcraft"
    "lightcraft"
    "effectcraft"
    "designcraft"
    "figcraft"
    "soundcraft"
    "wordcraft"
    "pdfcraft"
    "deckcraft"
    "cadcraft"
    "gridcraft"
  ] (name: builtins.fromJSON (builtins.readFile inputs."${name}-release"));

  # Upstream's native Linux tarballs include the GUI, CLI/MCP tools, desktop
  # entries, icons and MIME definitions. Release metadata is pinned in
  # flake.lock; `nix flake update` refreshes versions and archive checksums.
  # Catalog: https://getartcraft.com/apps
  # These are early-alpha apps. Keep existing office tools and MIME defaults;
  # native Wayland file drag-and-drop is not supported by every app upstream.
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
    name: release:
    let
      version = lib.removePrefix "v" release.tag_name;
      archiveName = "${name}-${version}-linux-x86_64.tar.gz";
      archive = lib.findFirst (
        asset: asset.name == archiveName
      ) (throw "${name}: release ${release.tag_name} has no ${archiveName}") release.assets;
      appLibraries =
        runtimeLibraries
        ++
          lib.optionals
            (builtins.elem name [
              "filmcraft"
              "effectcraft"
              "soundcraft"
              "deckcraft"
            ])
            [
              pkgs.alsa-lib
            ]
        ++ lib.optionals (name == "filmcraft") [ pkgs.libva ];
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
lib.mapAttrs mkCraft releases
