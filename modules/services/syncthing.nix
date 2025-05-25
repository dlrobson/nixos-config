{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.customModules.services.syncthing;

  # Create the folders configuration by conditionally including enabled folders
  folderConfigs =
    # Start with an empty attrset
    { }
    # Add Gill and Dan Shared folder if enabled
    // (if cfg.folders.gillAndDanShared.enable then {
      "Gill and Dan Shared Folder" = {
        inherit (cfg.folders.gillAndDanShared) path;
        inherit (cfg.folders.gillAndDanShared) devices;
        id = "7vpz3-ngn9u";
      };
    } else
      { })
    # Add Dan Files folder if enabled
    // (if cfg.folders.danFiles.enable then {
      "Dan files" = {
        inherit (cfg.folders.danFiles) path;
        inherit (cfg.folders.danFiles) devices;
        id = "rihg3-aiqta";
      };
    } else
      { })
    # Add Camera folder if enabled
    // (if cfg.folders.camera.enable then {
      "Camera" = {
        inherit (cfg.folders.camera) path;
        inherit (cfg.folders.camera) devices;
        id = "sm-g950w_nd8z-photos";
      };
    } else
      { });

in {
  options.customModules.services.syncthing = {
    enable = mkEnableOption "Syncthing service";

    user = mkOption {
      type = types.str;
      description = "User under which Syncthing runs";
    };

    dataDir = mkOption {
      type = types.str;
      description = "Directory where Syncthing data is stored";
    };

    configDir = mkOption {
      type = types.str;
      description = "Directory where Syncthing configuration is stored";
    };

    guiAddress = mkOption {
      type = types.str;
      default = "127.0.0.1:8384";
      description = "Address for the Syncthing web UI";
    };

    guiUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Username for the Syncthing UI";
    };

    guiPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Password for the Syncthing UI";
    };

    devices = mkOption {
      type = types.attrsOf (types.attrsOf types.anything);
      default = { };
      description = "Syncthing devices configuration";
    };

    folders = {
      gillAndDanShared = {
        enable = mkEnableOption "Gill and Dan Shared Folder";
        path = mkOption {
          type = types.str;
          description = "Path to the Gill and Dan Shared folder";
        };
        devices = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Devices to share this folder with";
        };
      };

      danFiles = {
        enable = mkEnableOption "Dan Files folder";
        path = mkOption {
          type = types.str;
          description = "Path to the Dan Files folder";
        };
        devices = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Devices to share this folder with";
        };
      };

      camera = {
        enable = mkEnableOption "Camera folder";
        path = mkOption {
          type = types.str;
          description = "Path to the Camera folder";
        };
        devices = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Devices to share this folder with";
        };
      };
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the Syncthing web UI port in the firewall";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;

      inherit (cfg) user;
      inherit (cfg) dataDir;
      inherit (cfg) configDir;
      inherit (cfg) guiAddress;

      overrideDevices = true;
      overrideFolders = true;

      settings = {
        options = {
          globalAnnounceEnabled = false;
          urAccepted = 1;
        };

        gui = {
          user = cfg.guiUser;
          password = cfg.guiPassword;
        };

        inherit (cfg) devices;
        folders = folderConfigs;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
