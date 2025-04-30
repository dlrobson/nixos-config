{ config, lib, pkgs, ... }:

let
  unstableTarball = builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
in {
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ../../common
    "${
      builtins.fetchTarball
      "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"
    }/nixos"
  ];

  # Direct import with overridden arguments
  home-manager.users.admin = import ../../home {
    username = "admin";
    homeDirectory = "/home/admin";
    inherit config pkgs lib;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # TODO: Required for 5G ethernet. Remove once this is the default kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Use the systemd-boot EFI boot loader.
  networking.hostName = "nixos";
  networking.hostId = "e3e68db8";

  # Disable GNOME3 auto-suspend feature
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ git ];
  };

  # Enabled services
  services.openssh.enable = true;
  services.vscode-server.enable = true;

  system.stateVersion = "24.11";
}
