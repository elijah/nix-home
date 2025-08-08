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
    pinentry_mac # macOS GPG pinentry (underscore not dash)
    yubikey-manager # YubiKey management (if you use hardware keys)

    # Certificate management
    step-cli # Certificate management
    certstrap # Certificate generation

    # Secure file deletion
    srm # Secure file removal
  ];

  # GPG configuration
  programs.gpg = {
    enable = true;
    settings = {
      # Use SHA256 by default
      personal-digest-preferences = "SHA256";
      cert-digest-algo = "SHA256";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
    };
  };

  # GPG agent configuration
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "mac";
    defaultCacheTtl = 3600;
    maxCacheTtl = 86400;
  };

  # Activate security measures
  system.activationScripts.security-setup.text = ''
    echo "Setting up security configurations..."
    
    # Create secure directories
    mkdir -p /Users/elw/.gnupg
    chmod 700 /Users/elw/.gnupg
    
    # Set proper permissions for SSH
    mkdir -p /Users/elw/.ssh
    chmod 700 /Users/elw/.ssh
    
    echo "Security setup completed"
  '';
}
