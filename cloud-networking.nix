{ pkgs, ... }:
{
  # Network and Cloud Tools
  # Comprehensive networking and cloud service management

  environment.systemPackages = with pkgs; [
    # Cloud CLI tools
    awscli2 # AWS CLI
    azure-cli # Azure CLI
    google-cloud-sdk # Google Cloud CLI

    # Kubernetes ecosystem
    kubectl # Kubernetes CLI
    kubectx # Kubernetes context switcher
    # kubens # Kubernetes namespace switcher (part of kubectx package)
    k9s # Kubernetes TUI
    kubernetes-helm # Kubernetes package manager (Helm)
    kustomize # Kubernetes configuration management
    argocd # GitOps CLI

    # Container tools
    docker-compose # Multi-container applications
    dive # Docker image analyzer
    skopeo # Container image operations

    # Infrastructure as Code
    terraform # Infrastructure provisioning
    terragrunt # Terraform wrapper
    packer # Image building
    vagrant # Development environments

    # Service mesh and networking
    istioctl # Istio service mesh
    linkerd # Linkerd service mesh

    # Network diagnostics
    dig # DNS lookup
    # nslookup # DNS lookup (not available in nixpkgs, use dig instead)
    whois # Domain information
    traceroute # Network path tracing
    mtr # Network diagnostic tool
    netcat # Network swiss army knife
    socat # Socket relay

    # Load testing and monitoring
    wrk # HTTP benchmarking
    hey # HTTP load generator

    # VPN and proxy tools
    wireguard-tools # WireGuard VPN
    openvpn # OpenVPN client

    # API tools
    postman # API testing (if available)
    insomnia # API testing

    # Database tools
    postgresql # PostgreSQL client
    mariadb-client # MySQL/MariaDB client
    redis # Redis client

    # File transfer
    rsync # File synchronization
    rclone # Cloud storage sync
    openssh # SSH client and utilities (includes scp, ssh, sftp)

    # Network security
    nmap # Network scanner
    masscan # High-speed port scanner
  ];

  # Environment variables for cloud tools
  environment.variables = {
    # AWS
    AWS_PAGER = "";
    AWS_DEFAULT_OUTPUT = "json";

    # Kubernetes
    KUBECONFIG = "$HOME/.kube/config";

    # Docker
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";
  };

  # Create necessary directories
  system.activationScripts.cloud-setup.text = ''
    echo "Setting up cloud and network tool directories..."
    
    # Create kubectl config directory
    mkdir -p /Users/elw/.kube
    
    # Create AWS config directory
    mkdir -p /Users/elw/.aws
    
    # Create Docker config directory
    mkdir -p /Users/elw/.docker
    
    echo "Cloud and network setup completed"
  '';
}
