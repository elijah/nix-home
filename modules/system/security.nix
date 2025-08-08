{ pkgs, ... }:
{
  # Security and Privacy Tools
  # Essential security utilities and privacy-focused tools

  environment.systemPackages = with pkgs; [
    # Password management and security
    pass # CLI password manager
    passage # Modern pass alternative
    age # File encryption tool
    sops # Secrets management

    # Network security
    nmap # Network discovery and security auditing
    wireshark # Network protocol analyzer
    tcpdump # Network packet capture

    # System security
    lynis # Security auditing tool
    chkrootkit # Rootkit detection (alternative to rkhunter)
    clamav # Antivirus

    # Privacy tools
    tor # Anonymous communication
    torsocks # Torify applications

    # Encryption and signing
    gnupg # GPG encryption
    pinentry-mac # macOS GPG pinentry
    yubikey-manager # YubiKey management (if you use hardware keys)

    # Certificate management
    step-cli # Certificate management
    certstrap # Certificate generation

    # Secure file deletion
    srm # Secure file removal
  ];

  # Note: GPG configuration and agent setup are handled in Home Manager
  # This module focuses on system-level security packages
}
