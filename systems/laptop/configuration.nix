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
    ./hardware/power-settings.nix
    ./services/syncthing-settings.nix
    ./services/restic.nix
    ../../common
    ../../modules/services/kmonad.nix
    "${
      builtins.fetchTarball
      "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz"
    }/nixos"
    "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/modules/age.nix"
  ];

  environment.systemPackages = [ (pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" {}) ];

  nixpkgs.overlays = [ (final: prev: { inherit unstable; }) ];

  home-manager = {
    users.robson = import ../../home {
      username = "robson";
      homeDirectory = "/home/robson";
      inherit config pkgs lib;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

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
