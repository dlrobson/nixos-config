{ config, lib, pkgs, ... }:

{
  imports = [
    "${
      builtins.fetchTarball
      "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"
    }/nixos"
  ];

  # Boot configuration
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    initrd.systemd.enable = true;
  };

  # Networking basics
  networking.networkmanager.enable = true;

  # Time and locale settings
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

  system.stateVersion = "25.05";
}
