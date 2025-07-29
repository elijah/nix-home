{ pkgs, ... }:
{
  # System Administration and DevOps Tools
  # Essential tools for system administration and operations

  environment.systemPackages = with pkgs; [
    # System monitoring and diagnostics
    htop                     # Process viewer
    iotop                    # I/O monitoring
    lsof                     # List open files
    nethogs                 # Network bandwidth by process
    iftop                   # Network bandwidth monitor
    
    # Log analysis
    lnav                    # Log navigator
    logrotate               # Log rotation
    
    # Performance analysis
    hyperfine               # Command-line benchmarking
    stress                  # System stress testing
    
    # File system tools
    ncdu                    # Disk usage analyzer
    tree                    # Directory tree display
    
    # Process management
    supervisor              # Process control system
    tmux                    # Terminal multiplexer
    screen                  # Terminal multiplexer
    
    # System information
    neofetch                # System information display
    macchina                # System information (Rust-based)
    
    # Backup and archiving
    borg                    # Backup tool
    restic                  # Backup tool
    duplicity               # Backup tool
    
    # Configuration management
    ansible                 # Configuration management
    # puppet                # Configuration management (if needed)
    # chef                  # Configuration management (if needed)
    
    # Infrastructure monitoring
    prometheus              # Metrics collection
    grafana                 # Metrics visualization
    
    # Database administration
    pgcli                   # PostgreSQL CLI with autocomplete
    mycli                   # MySQL CLI with autocomplete
    
    # Service discovery
    consul                  # Service discovery
    
    # Secrets management
    vault                   # HashiCorp Vault
    
    # Message queues
    # rabbitmq-server       # Message broker (if needed)
    
    # Reverse proxy and load balancing
    nginx                   # Web server/reverse proxy
    haproxy                 # Load balancer
    
    # SSL/TLS tools
    certbot                 # Let's Encrypt certificates
    mkcert                  # Local certificate generation
    
    # Network tools
    iperf3                  # Network performance testing
    tcpping                 # TCP ping utility
    
    # Container orchestration
    nomad                   # Workload orchestrator
    
    # Infrastructure testing
    testinfra               # Infrastructure testing
    
    # Chaos engineering
    # chaos-mesh            # Chaos engineering (if available)
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
    speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";
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
