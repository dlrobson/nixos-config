{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.customModules.services.syncthing;

  folderDefinitions = {
    gillAndDanShared = {
      name = "Gill and Dan Shared Folder";
      id = "7vpz3-ngn9u";
    };
    danFiles = {
      name = "Dan files";
      id = "rihg3-aiqta";
    };
    camera = {
      name = "Camera";
      id = "sm-g950w_nd8z-photos";
    };
  };

  folderConfigs = mapAttrs' (key: def:
    nameValuePair def.name {
      inherit (cfg.folders.${key}) path devices;
      inherit (def) id;
    }) (filterAttrs (key: def: cfg.folders.${key}.enable) folderDefinitions);

in {
  options.customModules.services.syncthing = {
    enable = mkEnableOption "Syncthing service";

    user = mkOption {
      type = types.nullOr types.str;
      default = null;
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

    folders = mapAttrs (key: def: {
      enable = mkEnableOption def.name;
      path = mkOption {
        type = types.str;
        description = "Path to the ${def.name}";
      };
      devices = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Devices to share this folder with";
      };
    }) folderDefinitions;
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;

      user = mkIf (cfg.user != null) cfg.user;
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
          insecureSkipHostcheck = true;
        };

        inherit (cfg) devices;
        folders = folderConfigs;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
