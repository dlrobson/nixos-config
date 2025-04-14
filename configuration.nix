# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
in
{
  imports = [
    ./hardware-configuration.nix
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    # (import "${home-manager}/nixos")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices = {
    "cryptkey" = {
      device = "/dev/disk/by-uuid/c93cada0-5b78-4922-8a18-bcec67432932";
      allowDiscards = true;
    };
    "cryptroot" = {
      device = "/dev/disk/by-uuid/40edc509-941a-4bbd-a436-86ec9703fc18";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthdda" = {
      device = "/dev/disk/by-uuid/0a36744b-7541-46cf-a697-1653f2024b3e";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthddb" = {
      device = "/dev/disk/by-uuid/c179bd70-1a65-43a7-a7bc-794ca558659a";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthddc" = {
      device = "/dev/disk/by-uuid/9cc8b846-d5df-4283-ad25-80141c6f09cf";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthddd" = {
      device = "/dev/disk/by-uuid/4f387ac5-fb24-44ec-bc3b-f68250ef11ce";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthdde" = {
      device = "/dev/disk/by-uuid/28d49dda-aa6c-4162-ad99-e7ab59660681";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
  };

  # TODO: Required for 5G ethernet. Remove once this is the default kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  networking.hostName = "nixos";
  networking.hostId = "e3e68db8";

  # TODO: Enable wireless?
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_GB.UTF-8";
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # Disable GNOME3 auto-suspend feature
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    # linger = true;
    packages = with pkgs; [
      git
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tpm2-tss # To enable automated unlocking of LUKS root partition
  ];

  # Enabled services
  services.openssh.enable = true;
  services.vscode-server.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
