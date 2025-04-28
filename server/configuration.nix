{ config, lib, pkgs, ... }:

let
  unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
in
{
  imports = [
    ./hardware-configuration.nix
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ../common
    ../hardware/luks/server.nix
  ];

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
    packages = with pkgs; [
      git
    ];
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss # To enable automated unlocking of LUKS root partition
  ];

  # Enabled services
  services.openssh.enable = true;
  services.vscode-server.enable = true;

  system.stateVersion = "24.11";
}
