{ config, lib, pkgs, ... }:

let cfg = config.customModules.services.kmonad;
in {
  options.customModules.services.kmonad = {
    enable = lib.mkEnableOption "Enable KMonad service";

    username = lib.mkOption {
      type = lib.types.str;
      default = "robson";
      description = "Username for KMonad service";
    };

    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/input/event0";
      description = "Input device path for KMonad";
    };

    configPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the KMonad configuration file";
    };
  };

  config = lib.mkIf cfg.enable {
    # Add user to the required groups for KMonad
    users.users.${cfg.username}.extraGroups = [ "input" "uinput" ];

    services.kmonad = {
      enable = true;
      keyboards = {
        builtinKeyboard = {
          inherit (cfg) device;
          config = builtins.readFile cfg.configPath;
        };
      };
    };
  };
}
