# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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
  ];

  boot.initrd.luks.devices = {
    "cryptkey" = {
      device = "/dev/disk/by-uuid/0b11b739-1461-4054-b6d6-ae660ecccc52";
      allowDiscards = true;
    };
    "cryptroot" = {
      device = "/dev/disk/by-uuid/bf7dd485-803e-4267-b349-86385e283fbd";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
  };

  networking.hostName = "nixos-laptop";

  users.users.robson = {
    isNormalUser = true;
    description = "robson";
    extraGroups = [
      "networkmanager"
      "wheel"
      # Kmonad Requirements
      "input"
      "uinput"
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
       # Using the dotfiles variable from variables.nix
       config = builtins.readFile "${variables.dotfiles}/kmonad/thinkpad.kbd";
     };
   };
  };
  services.syncthing = {
    enable = true;
    user = "robson";
    dataDir = "/home/robson/Documents";
    configDir = "/home/robson/Documents/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      gui = {
        user = variables.syncthing_gui_user;
        password = variables.syncthing_gui_password;
      };
      devices = {
        "server" = {
          id = variables.syncthing_server_id;
        };
      };
      folders = {
        "Gill and Dan Shared Folder" = {
          path = "/home/robson/Documents/gill-and-dan-shared";
          devices = [ "server" ];
          id = "7vpz3-ngn9u";
        };
        "Dan files" = {
          path = "/home/robson/Documents/dan-files";
          devices = [ "server" ];
          id = "rihg3-aiqta";
        };
        "Camera" = {
          path = "/home/robson/Pictures/sm-g950w_nd8z-photos";
          devices = [ "server" ];
          id = "sm-g950w_nd8z-photos";
        };
      };
    };
  };

  system.stateVersion = "24.11";
}
