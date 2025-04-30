{ config, lib, pkgs, ... }:

let cfg = config.customModules.services.syncthing;
in {
  options.customModules.services.syncthing = {
    enable = lib.mkEnableOption "Enable syncthing service";

    username = lib.mkOption {
      type = lib.types.str;
      default = "robson";
      description = "Username for the syncthing service";
    };

    homeDir = lib.mkOption {
      type = lib.types.str;
      description = "Home directory for the syncthing user";
      default = "/home/robson";
    };

    guiUser = lib.mkOption {
      type = lib.types.str;
      description = "Username for the Syncthing GUI";
      default = "admin";
    };

    guiPassword = lib.mkOption {
      type = lib.types.str;
      description = "Password for the Syncthing GUI";
      default = "admin";
    };

    serverId = lib.mkOption {
      type = lib.types.str;
      description = "Device ID for the server";
      example =
        "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = cfg.username;
      dataDir = "${cfg.homeDir}/Documents";
      configDir = "${cfg.homeDir}/Documents/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        gui = {
          user = cfg.guiUser;
          password = cfg.guiPassword;
        };
        devices = { "server" = { id = cfg.serverId; }; };
        folders = {
          "Gill and Dan Shared Folder" = {
            path = "${cfg.homeDir}/Documents/gill-and-dan-shared";
            devices = [ "server" ];
            id = "7vpz3-ngn9u";
          };
          "Dan files" = {
            path = "${cfg.homeDir}/Documents/dan-files";
            devices = [ "server" ];
            id = "rihg3-aiqta";
          };
          "Camera" = {
            path = "${cfg.homeDir}/Pictures/sm-g950w_nd8z-photos";
            devices = [ "server" ];
            id = "sm-g950w_nd8z-photos";
          };
        };
      };
    };
  };
}
