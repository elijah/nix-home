{ pkgs, lib, ... }:
{
  # System Administration and DevOps Tools
  # Essential tools for system administration and operations

  environment.systemPackages = with pkgs; [
    # System monitoring and diagnostics
    htop # Process viewer
    # iotop                  # I/O monitoring (Linux only - not available on macOS)
    lsof # List open files
    # nethogs               # Network bandwidth by process (Linux only)
    iftop # Network bandwidth monitor

    # Log analysis
    lnav # Log navigator
    logrotate # Log rotation

    # Performance analysis
    hyperfine # Command-line benchmarking
    stress # System stress testing

    # File system tools
    ncdu # Disk usage analyzer
    tree # Directory tree display

    # Process management
    # supervisor            # Process control system (not available in nixpkgs)
    tmux # Terminal multiplexer
    screen # Terminal multiplexer

    # System information
    neofetch # System information display
    macchina # System information (Rust-based)

    # Backup and archiving
    borgbackup # Backup tool (borg)
    restic # Backup tool
    duplicity # Backup tool

    # Configuration management
    ansible # Configuration management
    # puppet                # Configuration management (if needed)
    # chef                  # Configuration management (if needed)

    # Infrastructure monitoring
    prometheus # Metrics collection
    grafana # Metrics visualization

    # Database administration
    pgcli # PostgreSQL CLI with autocomplete
    mycli # MySQL CLI with autocomplete

    # Service discovery
    consul # Service discovery

    # Secrets management
    vault # HashiCorp Vault

    # Message queues
    # rabbitmq-server       # Message broker (if needed)

    # Reverse proxy and load balancing
    nginx # Web server/reverse proxy
    haproxy # Load balancer

    # SSL/TLS tools
    certbot # Let's Encrypt certificates
    mkcert # Local certificate generation

    # Network tools
    iperf3 # Network performance testing
    # tcpping               # TCP ping utility (not available in nixpkgs)

    # Container orchestration
    nomad # Workload orchestrator

    # Infrastructure testing
    # testinfra             # Infrastructure testing (not available in nixpkgs)

    # Chaos engineering
    # chaos-mesh            # Chaos engineering (if available)
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-specific system administration tools
    iotop # I/O monitoring (Linux only)
    nethogs # Network bandwidth by process (Linux only)
    strace # System call tracer (Linux only)
    sysstat # System statistics (sar, iostat, etc.)
    tcpdump # Network packet analyzer
    perf-tools # Performance analysis tools
    bpftrace # High-level tracing language for eBPF
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific system administration tools
    # darwin.ps_mem         # Memory usage by process (macOS equivalent of smem)
    # Add other macOS-specific tools here as needed
  ];

  # System administration aliases and functions
  environment.shellAliases = {
    # System monitoring shortcuts
    ports = "lsof -i -P -n | grep LISTEN";
    processes = "ps aux | grep -v grep | grep";
    netstat = "ss -tuln";

    # Log viewing shortcuts
    syslog = "tail -f /var/log/system.log";

    # Quick system info
    meminfo = "cat /proc/meminfo";
    cpuinfo = "cat /proc/cpuinfo";
    diskspace = "df -h";

    # Network diagnostics
    pingtest = "ping -c 4 8.8.8.8";
    speedtest-py = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";
  };

  # System administration directories
  system.activationScripts.sysadmin-setup.text = ''
    echo "Setting up system administration directories..."
    
    # Create directories for system administration
    mkdir -p /Users/elw/.config/monitoring
    mkdir -p /Users/elw/.config/backups
    mkdir -p /Users/elw/Scripts/maintenance
    mkdir -p /Users/elw/Logs
    
    echo "System administration setup completed"
  '';
}
