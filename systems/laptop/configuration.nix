{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware/hardware-configuration.nix
    ./hardware/luks.nix
    ./hardware/power-settings.nix
    ./services/syncthing-settings.nix
    ../../common
    ../../modules/services/kmonad.nix
    "${
      builtins.fetchTarball
      "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"
    }/nixos"
  ];

  # Direct import with overridden arguments
  home-manager.users.robson = import ../../home {
    username = "robson";
    homeDirectory = "/home/robson";
    inherit config pkgs lib;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  networking.hostName = "nixos-laptop";

  users.users.robson = {
    isNormalUser = true;
    description = "robson";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ libreoffice-qt ];
  };

  # Docker configuration for rootless mode
  virtualisation.docker.enable = true;

  # TODO: Review: https://search.nixos.org/options?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=tailscale
  services.tailscale.enable = true;

  customModules.services.kmonad = {
    enable = true;
    username = "robson";
    device = "/dev/input/event0";
    configPath = builtins.toString ../../home/kmonad/thinkpad.kbd;
  };

  system.stateVersion = "24.11";
}
