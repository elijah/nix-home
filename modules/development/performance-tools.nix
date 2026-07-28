{ pkgs, lib, config, ... }:
{
  # Performance Monitoring Tools
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager). The darwin-only Dock/Finder/trackpad
  # system defaults live in modules/system/performance.nix instead, since
  # those are nix-darwin `system.defaults` options with no home-manager
  # equivalent.

  home.packages = with pkgs; [
    # System monitoring
    htop # Interactive process viewer
    btop # Modern resource monitor
    iotop # I/O monitoring
    nethogs # Network usage by process
    bandwhich # Network utilization monitor

    # Performance analysis
    hyperfine # Command-line benchmarking
    pv # Pipe viewer for data transfer rates
    stress # System stress testing
    sysbench # System benchmark suite

    # Disk analysis
    ncdu # NCurses disk usage
    dust # Modern du replacement
    duf # Modern df replacement

    # Network performance
    iperf3 # Network performance testing
    speedtest-cli # Internet speed testing

    # Process management
    procs # Modern ps replacement
    killall # Kill processes by name

    # File system monitoring
    watchman # File watcher service
    entr # Run commands when files change
    watchexec # Execute commands on file changes

    # Memory and debugging analysis
    lldb # LLVM debugger with memory debugging features
    gdb # GNU debugger

    # Note: macOS has excellent built-in memory debugging tools:
    # - leaks: detect memory leaks in running processes
    # - vmmap: analyze virtual memory usage
    # - malloc_history: track malloc/free history
    # - heap: analyze heap contents
    # - Instruments.app: comprehensive profiling GUI
    # - AddressSanitizer: compile with -fsanitize=address
    # - LeakSanitizer: compile with -fsanitize=leak

    # System information
    fastfetch # System information display
    macchina # Fast system info tool

    # Log analysis
    lnav # Log navigator

    # Temperature monitoring (if supported)
    # sensors                # Hardware sensor monitoring
  ];

  # Performance monitoring aliases
  home.shellAliases = {
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
    sysinfo = "fastfetch";

    # Compile with sanitizers
    compile-asan = "clang -fsanitize=address -g";
    compile-lsan = "clang -fsanitize=leak -g";
    compile-msan = "clang -fsanitize=memory -g";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    # macOS-specific: built-in temperature/memory debugging tools
    temp = "sudo powermetrics --samplers smc -n 1 | grep -E 'CPU|GPU' | grep -E 'temp|Temp'";
    memcheck = "lldb --batch --one-line 'process launch --stop-at-entry' --one-line 'target modules dump symtab'";
    leakcheck = "leaks"; # Built-in macOS leak detection
    vmmap = "vmmap"; # Built-in macOS virtual memory analyzer
    malloc-history = "malloc_history"; # Built-in macOS malloc tracking
  };

  # Create performance monitoring directories
  home.activation.performanceSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    verboseEcho "Setting up performance monitoring..."
    run mkdir -p "${config.home.homeDirectory}/.local/share/monitoring"
    run mkdir -p "${config.home.homeDirectory}/.local/share/logs"
    run mkdir -p "${config.home.homeDirectory}/Pictures/Screenshots"
  '';
}
