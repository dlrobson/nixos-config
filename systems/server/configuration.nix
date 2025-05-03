{ config, lib, pkgs, ... }:
let
  variables = import ./variables.nix;

  # Define unstable here at the top level
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  unstable = import unstableTarball {
    config = { allowUnfree = true; };
    inherit (pkgs) system;
  };
in {
  imports = [
    ./hardware/hardware-configuration.nix
    ./hardware/luks.nix
    ../../common
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    "${
      builtins.fetchTarball
      "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"
    }/nixos"
  ];

  nixpkgs.overlays = [ (final: prev: { inherit unstable; }) ];

  home-manager = {
    users.admin = import ../../home {
      username = "admin";
      homeDirectory = "/home/admin";
      inherit config pkgs lib;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # TODO: Required for 5G ethernet. Remove once this is the default kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Use the systemd-boot EFI boot loader.
  networking.hostName = "nixos";
  networking.hostId = "e3e68db8";

  # Disable GNOME3 auto-suspend feature
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIc+tZ6XSUqF/7g4IPQXWojEYfa2VI92MrZol7UZV4jd"
    ];
  };

  # Enabled services
  services = {
    openssh.enable = true;

    vscode-server.enable = true;
    tailscale.enable = true;
  };

  system.stateVersion = "24.11";
}
