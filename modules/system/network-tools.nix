{ pkgs, ... }:
{
  # Network Tools and Configuration
  # Comprehensive networking utilities and optimizations

  environment.systemPackages = with pkgs; [
    # Network diagnostics
    dig # DNS lookup utility
    # nslookup # DNS lookup utility (not available in nixpkgs, use dig instead)
    whois # Domain information lookup
    traceroute # Network route tracing
    mtr # Network diagnostic tool
    ping # Network connectivity test

    # Network monitoring
    nmap # Network discovery and security auditing
    masscan # High-speed port scanner
    netcat-openbsd # Network swiss army knife
    socat # Socket relay
    tcpdump # Network packet capture
    wireshark # Network protocol analyzer

    # Network performance
    iperf3 # Network performance testing
    speedtest-cli # Internet speed testing

    # HTTP tools
    curl # HTTP client
    wget # File downloader
    httpie # Human-friendly HTTP client
    aria2 # Advanced downloader

    # VPN and proxy
    wireguard-tools # WireGuard VPN utilities
    openvpn # OpenVPN client

    # Network utilities
    rsync # File synchronization over network
    openssh # SSH client and utilities (includes scp, ssh, sftp)

    # SSL/TLS tools
    openssl # SSL/TLS toolkit
    certstrap # Certificate generation
    step-cli # Certificate management

    # Network file sharing
    samba # SMB/CIFS file sharing

    # Network security
    nftables # Netfilter tables (if available)
  ];

  # Note: Network diagnostic scripts would be configured in Home Manager
  # This module focuses on system-level network packages and configuration
}
