{ pkgs, lib, ... }:
{
  # Security and Privacy Tools
  # Essential security utilities and privacy-focused tools
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager).

  home.packages = with pkgs; [
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
    # chkrootkit # Rootkit detection (not compatible with current macOS SDK)
    clamav # Antivirus

    # Privacy tools
    tor # Anonymous communication
    torsocks # Torify applications

    # Encryption and signing
    gnupg # GPG encryption
    yubikey-manager # YubiKey management (if you use hardware keys)

    # Certificate management
    step-cli # Certificate management
    certstrap # Certificate generation

    # Secure file deletion
    srm # Secure file removal
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    pinentry_mac # macOS GPG pinentry (underscore not dash)
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    pinentry-curses # Terminal-based GPG pinentry for headless/WSL2 use
  ];

  # Note: GPG configuration and agent setup are handled in Home Manager
  # This module focuses on shared security packages
}
