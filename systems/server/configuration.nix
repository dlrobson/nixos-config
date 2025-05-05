{ config, lib, pkgs, ... }:
let
  variables = import ./variables.nix;
in {
  imports = [
    ./hardware/hardware-configuration.nix
    ./hardware/luks.nix
    ../../common
    ../../modules/services/home-manager.nix
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  customModules.services.homeManager = {
    enable = true;
    username = "admin";
    homeDirectory = "/home/admin";
  };

  # TODO: Required for 5G ethernet. Remove once this is the default kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Use the systemd-boot EFI boot loader.
  networking = {
    hostId = "e3e68db8";
    hostName = "nixos";
  };

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
