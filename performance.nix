{ pkgs, ... }:
{
  # Performance Monitoring and System Optimization
  # Tools and configurations for monitoring and optimizing system performance

  environment.systemPackages = with pkgs; [
    # System monitoring
    htop                     # Interactive process viewer
    btop                     # Modern resource monitor
    iotop                    # I/O monitoring
    nethogs                 # Network usage by process
    bandwhich               # Network utilization monitor
    
    # Performance analysis
    hyperfine               # Command-line benchmarking
    pv                      # Pipe viewer for data transfer rates
    stress                  # System stress testing
    sysbench                # System benchmark suite
    
    # Disk analysis
    ncdu                    # NCurses disk usage
    dust                    # Modern du replacement
    duf                     # Modern df replacement
    
    # Network performance
    iperf3                  # Network performance testing
    speedtest-cli           # Internet speed testing
    
    # Process management
    procs                   # Modern ps replacement
    killall                 # Kill processes by name
    
    # File system monitoring
    watchman                # File watcher service
    entr                    # Run commands when files change
    watchexec               # Execute commands on file changes
    
    # Memory analysis
    valgrind                # Memory debugging and profiling
    
    # System information
    neofetch                # System information display
    macchina                # Fast system info tool
    
    # Log analysis
    lnav                    # Log navigator
    
    # Temperature monitoring (if supported)
    # sensors                # Hardware sensor monitoring
  ];

  # System performance optimizations
  system.defaults = {
    # Dock optimizations
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      show-recents = false;
      static-only = true;
    };
    
    # Finder optimizations
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };
    
    # Trackpad optimizations
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    
    # Energy saving
    screencapture.location = "~/Pictures/Screenshots";
  };

  # Performance monitoring aliases
  environment.shellAliases = {
    # Quick system checks
    cpu = "htop --sort-key PERCENT_CPU";
    mem = "htop --sort-key PERCENT_MEM";
    disk = "duf";
    network = "nethogs";
    
    # Process management
    psk = "procs --tree";
    psmem = "procs --sortd memory";
    pscpu = "procs --sortd cpu";
    
    # Performance testing
    speedtest = "speedtest-cli";
    disktest = "dd if=/dev/zero of=/tmp/test bs=1M count=1024 && rm /tmp/test";
    
    # System info
    sysinfo = "neofetch";
    temp = "sudo powermetrics --samplers smc -n 1 | grep -E 'CPU|GPU' | grep -E 'temp|Temp'";
  };

  # Create performance monitoring directories
  system.activationScripts.performance-setup.text = ''
    echo "Setting up performance monitoring..."
    
    # Create directories for logs and monitoring data
    mkdir -p /Users/elw/.local/share/monitoring
    mkdir -p /Users/elw/.local/share/logs
    
    # Create screenshots directory
    mkdir -p /Users/elw/Pictures/Screenshots
    
    echo "Performance monitoring setup completed"
  '';
}
