{ config, pkgs, ... }: 
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Hibernation support
    kernelParams = [
      "resume_offset=$(stat -f %i /.swapvol/swapfile)"
      "resume=/dev/mapper/crypted"
    ];
    resumeDevice = "/dev/mapper/crypted";
  };

  users.users.wizdore = {
    isNormalUser = true;
    description = "Shaon";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  virtualisation.docker.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.git;

    config = {
      user = {
        name = "Wizdore";
        email = "wizdore@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };


  environment.variables.EDITOR = "nvim";

  services.tailscale.enable = true;
  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "swift";
    allowedUDPPorts = [ 41641 51820 ];
    trustedInterfaces = [ "tailscale0" "wg0" ];
  };

  # Timezone and Localization
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # CLI-only environment
  services.xserver.enable = false;
  environment.noXlibs = true;

  # CLI tools and utilities
  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    bat
    bluetui
    btop
    chezmoi
    curl
    devbox
    docker
    direnv
    du-dust
    dust
    eza
    fd
    fzf
    git
    htop
    impala
    lazygit
    lazydocker
    magic-wormhole
    neovim
    powertop
    procs
    ripgrep
    rsync
    starship
    tealdeer
    tldr
    tmux
    weechat-unwrapped
    wget
    yazi
    zoxide
    zsh
  ];

  # Shell configuration
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };

    # Better terminal multiplexer
    tmux = {
      enable = true;
      clock24 = true;
    };
  };

  # Power Management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    hibernation = {
      enable = true;
    };
  };

  # Swap Configuration
  swapDevices = [
    {
      device = "/.swapvol/swapfile";
      randomEncryption.enable = true;
    }
  ];

  # Console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable periodic garbage collection
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.auto-optimise-store = true;
  };

  services.openssh.enable = true;
  system.stateVersion = "24.11"; 
}
