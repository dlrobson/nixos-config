{ config, lib, pkgs, ... }:

let
  unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
  variables = import ./variables.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ../../common
    ../../modules/services/syncthing.nix
    ../../modules/services/kmonad.nix
  ];

  networking.hostName = "nixos-laptop";

  users.users.robson = {
    isNormalUser = true;
    description = "robson";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      brave
      vscode
      alacritty
      htop
      git
      libreoffice-qt
      slack
    ];
  };

  # TODO: Review: https://search.nixos.org/options?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=tailscale
  services.tailscale.enable = true;
  
  customModules.services.kmonad = {
    enable = true;
    username = "robson";
    device = "/dev/input/event0";
    configPath = "${variables.dotfiles}/kmonad/thinkpad.kbd";
  };
  
  customModules.services.syncthing = {
    enable = true;
    username = "robson";
    homeDir = "/home/robson";
    guiUser = variables.syncthing_gui_user;
    guiPassword = variables.syncthing_gui_password;
    serverId = variables.syncthing_server_id;
  };

  system.stateVersion = "24.11";
}
