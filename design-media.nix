{ pkgs, ... }:
{
  # Design and Media Tools
  # Creative tools for design, video, audio, and image processing

  environment.systemPackages = with pkgs; [
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
  environment.variables = {
    # ImageMagick security policy (if needed)
    MAGICK_HOME = "${pkgs.imagemagick}";
  };

  # Create directories for media tools
  system.activationScripts.media-setup.text = ''
    echo "Setting up media and design tool directories..."
    
    # Create directories for media processing
    mkdir -p /Users/elw/Media/Processing
    mkdir -p /Users/elw/Media/Output
    mkdir -p /Users/elw/Media/Screenshots
    
    echo "Media and design setup completed"
  '';
}
