{ config, lib, pkgs, ... }:

let variables = import ./variables.nix;
in {
  imports = [
    ./hardware/hardware-configuration.nix
    ./hardware/luks.nix
    ./hardware/power-settings.nix
    ./services/syncthing-settings.nix
    ../../common
    ../../modules/services/kmonad.nix
    ../../modules/services/home-manager.nix
  ];

  customModules.services.homeManager = {
    enable = true;
    username = "robson";
    homeDirectory = "/home/robson";
  };

  networking.hostName = "nixos-laptop";

  users.users.robson = {
    isNormalUser = true;
    description = "robson";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ libreoffice-qt ];
  };

  # TODO: Review: https://search.nixos.org/options?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=tailscale
  services.tailscale.enable = true;

  customModules.services.kmonad = {
    enable = true;
    username = "robson";
    device = "/dev/input/event0";
    configPath = builtins.toString ../../home/kmonad/thinkpad.kbd;
  };
}
