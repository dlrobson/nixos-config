{ config, lib, pkgs, ... }:

let
  unstableTarball = builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
  variablesFile = ./variables.nix;
  variables =
    if builtins.pathExists variablesFile then import variablesFile else { };
in {
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ../../common
    ../../modules/services/syncthing.nix
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
    packages = with pkgs; [ vscode alacritty htop git libreoffice-qt slack ];
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

  customModules.services.syncthing = {
    enable = true;
    username = "robson";
    homeDir = "/home/robson";
    serverId = variables.syncthing_server_id or "";
  } // lib.optionalAttrs (variables ? syncthing_gui_user) {
    guiUser = variables.syncthing_gui_user;
  } // lib.optionalAttrs (variables ? syncthing_gui_password) {
    guiPassword = variables.syncthing_gui_password;
  };

  system.stateVersion = "24.11";
}
