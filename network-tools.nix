{ pkgs, ... }:
{
  # Network Tools and Configuration
  # Comprehensive networking utilities and optimizations

  environment.systemPackages = with pkgs; [
    # Network diagnostics
    dig                     # DNS lookup utility
    nslookup               # DNS lookup utility
    whois                  # Domain information lookup
    traceroute             # Network route tracing
    mtr                    # Network diagnostic tool
    ping                   # Network connectivity test
    
    # Network monitoring
    nmap                   # Network discovery and security auditing
    masscan               # High-speed port scanner
    netcat                # Network swiss army knife
    socat                 # Socket relay
    tcpdump               # Network packet capture
    wireshark             # Network protocol analyzer
    
    # Network performance
    iperf3                # Network performance testing
    speedtest-cli         # Internet speed testing
    
    # HTTP tools
    curl                  # HTTP client
    wget                  # File downloader
    httpie                # Human-friendly HTTP client
    aria2                 # Advanced downloader
    
    # VPN and proxy
    wireguard-tools       # WireGuard VPN utilities
    openvpn              # OpenVPN client
    
    # Network utilities
    rsync                # File synchronization over network
    scp                  # Secure copy over SSH
    
    # SSL/TLS tools
    openssl              # SSL/TLS toolkit
    certstrap            # Certificate generation
    step-cli             # Certificate management
    
    # Network file sharing
    samba                # SMB/CIFS file sharing
    
    # Network security
    nftables             # Netfilter tables (if available)
  ];

  # Network optimization and configuration
  home.file = {
    ".local/bin/network-info" = {
      text = ''
        #!/usr/bin/env bash
        # Network information and diagnostics script
        
        set -euo pipefail
        
        log() {
            echo "=== $* ==="
        }
        
        log "Network Interfaces"
        ifconfig | grep -E "^[a-z]|inet "
        echo
        
        log "Default Route"
        route -n get default 2>/dev/null || netstat -rn | head -5
        echo
        
        log "DNS Configuration"
        cat /etc/resolv.conf 2>/dev/null || scutil --dns | head -20
        echo
        
        log "Active Network Connections"
        netstat -an | head -20
        echo
        
        log "Wi-Fi Information"
        networksetup -getairportnetwork en0 2>/dev/null || echo "Wi-Fi info not available"
        echo
        
        log "Public IP Address"
        curl -s https://ipinfo.io/ip || echo "Cannot determine public IP"
        echo
        
        log "Internet Connectivity Test"
        ping -c 3 8.8.8.8 >/dev/null 2>&1 && echo "✅ Internet connectivity OK" || echo "❌ Internet connectivity failed"
        echo
        
        log "DNS Resolution Test"
        nslookup google.com >/dev/null 2>&1 && echo "✅ DNS resolution OK" || echo "❌ DNS resolution failed"
      '';
      executable = true;
    };
    
    ".local/bin/network-scan" = {
      text = ''
        #!/usr/bin/env bash
        # Network scanning and discovery
        
        set -euo pipefail
        
        # Get local network range
        NETWORK=$(route -n get default 2>/dev/null | grep interface | awk '{print $2}' | head -1)
        if [[ -z "$NETWORK" ]]; then
            echo "❌ Cannot determine network interface"
            exit 1
        fi
        
        LOCAL_IP=$(ifconfig "$NETWORK" | grep "inet " | awk '{print $2}' | head -1)
        if [[ -z "$LOCAL_IP" ]]; then
            echo "❌ Cannot determine local IP address"
            exit 1
        fi
        
        # Extract network range (assumes /24)
        NETWORK_RANGE=$(echo "$LOCAL_IP" | sed 's/\.[0-9]*$/\.0\/24/')
        
        echo "🔍 Scanning network: $NETWORK_RANGE"
        echo "📍 Your IP: $LOCAL_IP"
        echo
        
        if command -v nmap >/dev/null 2>&1; then
            echo "🌐 Discovering hosts..."
            nmap -sn "$NETWORK_RANGE" | grep -E "Nmap scan report|MAC Address"
        else
            echo "❌ nmap not available. Install with: nix-env -iA nixpkgs.nmap"
        fi
      '';
      executable = true;
    };
    
    ".local/bin/port-check" = {
      text = ''
        #!/usr/bin/env bash
        # Port connectivity checker
        
        set -euo pipefail
        
        if [[ $# -lt 2 ]]; then
            echo "Usage: $0 <host> <port> [timeout]"
            echo "Example: $0 google.com 443"
            exit 1
        fi
        
        HOST="$1"
        PORT="$2"
        TIMEOUT="''${3:-5}"
        
        echo "🔌 Checking $HOST:$PORT (timeout: ''${TIMEOUT}s)"
        
        if command -v nc >/dev/null 2>&1; then
            if nc -z -w "$TIMEOUT" "$HOST" "$PORT" 2>/dev/null; then
                echo "✅ Port $PORT is open on $HOST"
            else
                echo "❌ Port $PORT is closed or filtered on $HOST"
            fi
        elif command -v telnet >/dev/null 2>&1; then
            timeout "$TIMEOUT" telnet "$HOST" "$PORT" </dev/null >/dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                echo "✅ Port $PORT is open on $HOST"
            else
                echo "❌ Port $PORT is closed or filtered on $HOST"
            fi
        else
            echo "❌ Neither nc nor telnet available for port checking"
            exit 1
        fi
      '';
      executable = true;
    };
  };

  # Network aliases and shortcuts
  environment.shellAliases = {
    # Network information
    myip = "curl -s https://ipinfo.io/ip";
    localip = "ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1";
    netinfo = "network-info";
    
    # DNS tools
    dns = "dig +short";
    dnsfull = "dig";
    dnsreverse = "dig -x";
    
    # Network testing
    pingtest = "ping -c 4 8.8.8.8";
    speedtest = "speedtest-cli";
    portscan = "nmap -F";
    
    # HTTP testing
    headers = "curl -I";
    curltime = "curl -w '@/dev/stdin' -o /dev/null -s";
    
    # Network monitoring
    netwatch = "netstat -an | grep LISTEN";
    connections = "lsof -i";
    
    # Quick network fixes
    dnsflush = "sudo dscacheutil -flushcache";
    netrestart = "sudo ifconfig en0 down && sudo ifconfig en0 up";
  };

  # Network monitoring and logging setup
  system.activationScripts.network-setup.text = ''
    echo "Setting up network monitoring..."
    
    # Create network monitoring directories
    mkdir -p /Users/elw/.local/share/network-logs
    mkdir -p /Users/elw/.config/network
    
    # Create network configuration backup
    if [[ -f /etc/resolv.conf ]]; then
        cp /etc/resolv.conf /Users/elw/.config/network/resolv.conf.backup 2>/dev/null || true
    fi
    
    echo "Network setup completed"
  '';
}
