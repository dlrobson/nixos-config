{ config, lib, pkgs, ... }:

let variables = import ../variables.nix;
in {
  imports = [
    ./hardware/hardware-configuration.nix
    ./hardware/luks.nix
    ./hardware/power-settings.nix
    ../../modules
  ];

  customModules.services = {
    homeManager = {
      enable = true;
      users = { robson = { desktopEnable = true; }; };
    };
    syncthing = {
      enable = true;
      user = "robson";
      dataDir = "/home/robson/Documents";
      configDir = "/home/robson/Documents/.config/syncthing";
      guiUser = lib.optionalString (variables ? syncthing_gui_user)
        variables.syncthing_gui_user;
      guiPassword = lib.optionalString (variables ? syncthing_gui_password)
        variables.syncthing_gui_password;
      devices = {
        "server" = { id = variables.syncthing_server_id; };
        "gill_laptop" = { id = variables.synthing_gill_laptop_id; };
      };
      folders = {
        gillAndDanShared = {
          enable = true;
          path = "/home/robson/Documents/gill-and-dan-shared";
          devices = [ "server" "gill_laptop" ];
        };
        danFiles = {
          enable = true;
          path = "/home/robson/Documents/dan-files";
          devices = [ "server" ];
        };
        camera = {
          enable = true;
          path = "/home/robson/Pictures/sm-g950w_nd8z-photos";
          devices = [ "server" ];
        };
      };
      openFirewall = true;
    };
  };

  networking.hostName = "nixos-laptop";

  users.users.robson = {
    isNormalUser = true;
    description = "robson";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ libreoffice-qt ];
  };

  services.tailscale.enable = true;

  customModules.services.kmonad = {
    enable = true;
    username = "robson";
    device = "/dev/input/event0";
    configPath = builtins.toString ../../assets/thinkpad.kbd;
  };
}
