{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # adjust if needed

  networking.hostName = "hermes";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.rice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    initialPassword = "changeme";
  };

  # Sudo
  security.sudo.wheelNeedsPassword = false;

  # Packages
  environment.systemPackages = with pkgs; [
    # Hermes deps
    uv
    python311
    nodejs_20
    ripgrep
    ffmpeg

    # Dev essentials
    git
    curl
    wget
    vim
    htop
    tmux
    unzip
    jq

    # Nix tools
    nix-index
  ];

  # Docker (hermes can use it as a terminal backend)
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  users.extraGroups.docker.members = [ "rice" ];

  # SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "24.11";
}
