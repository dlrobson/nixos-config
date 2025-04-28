{ config, lib, pkgs, ... }:

let
  unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
  variables = import ./variables.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../hardware/luks/laptop.nix
    ../modules/services/syncthing.nix
  ];

  networking.hostName = "nixos-laptop";

  users.users.robson = {
    isNormalUser = true;
    description = "robson";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input" # Kmonad
      "uinput" # Kmonad
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
 
  environment.systemPackages = with pkgs; [
    tpm2-tss # To enable automated unlocking of LUKS root partition
  ];

  services.tailscale.enable = true;
  services.kmonad = {
   enable = true;
   keyboards = {
     builtinKeyboard = { 
       device = "/dev/input/event0";
       config = builtins.readFile "${variables.dotfiles}/kmonad/thinkpad.kbd";
     };
   };
  };
  
  # Enable our custom syncthing module with specific options
  customModules.services.syncthing = {
    enable = true;
    username = "robson";
    homeDir = "${config.users.users.robson.home}";
    guiUser = variables.syncthing_gui_user;
    guiPassword = variables.syncthing_gui_password;
    serverId = variables.syncthing_server_id;
  };

  system.stateVersion = "24.11";
}
