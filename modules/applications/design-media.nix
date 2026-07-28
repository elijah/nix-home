{ pkgs, lib, config, ... }:
{
  # Design and Media Tools
  # Creative tools for design, video, audio, and image processing
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager).

  home.packages = with pkgs; [
    # Image processing and editing
    imagemagick # Image manipulation
    graphicsmagick # Alternative image manipulation
    oxipng # PNG optimizer
    jpegoptim # JPEG optimizer
    pngquant # PNG quantization

    # Vector graphics and design
    inkscape # Vector graphics editor
    # gimp                   # Raster graphics editor (large package)

    # Image viewers
    feh # Lightweight image viewer

    # Video tools
    ffmpeg # Video/audio processing
    yt-dlp # Modern video downloader (successor to youtube-dl)

    # Audio tools
    sox # Audio processing
    lame # MP3 encoder
    flac # FLAC audio codec

    # 3D and CAD (if interested)
    # blender                # 3D creation suite (very large)
    # freecad                # CAD software

    # Color and design utilities
    pastel # Color manipulation

    # Font management
    fontconfig # Font configuration

    # Screen capture and recording
    # scrot                  # Screenshot utility (Linux-focused)

    # PDF tools
    poppler # PDF rendering library
    qpdf # PDF manipulation

    # Diagram creation
    graphviz # Graph visualization
    plantuml # UML diagrams

    # Image format conversion
    libwebp # WebP image format tools and library

    # Metadata tools
    exiftool # Metadata reader/writer
  ];

  # Environment variables for media tools
  home.sessionVariables = {
    # ImageMagick security policy (if needed)
    MAGICK_HOME = "${pkgs.imagemagick}";
  };

  # Create directories for media tools
  home.activation.mediaSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    verboseEcho "Setting up media and design tool directories..."
    run mkdir -p "${config.home.homeDirectory}/Media/Processing"
    run mkdir -p "${config.home.homeDirectory}/Media/Output"
    run mkdir -p "${config.home.homeDirectory}/Media/Screenshots"
  '';
}
