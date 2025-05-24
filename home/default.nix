{ lib, pkgs, config, ... }:
with lib;
let cfg = config.home-manager-configuration;
in {
  imports = [ ./programs ./desktop ];

  options.home-manager-configuration = {
    enable = mkEnableOption "enable home-manager configuration";
    desktopConfigEnable =
      mkEnableOption "enable home-manager desktop configuration";
    username = mkOption {
      type = types.str;
      default = builtins.getEnv "USER";
      example = "myusername";
      description = ''
        The username of the user to manage.
        This is usually the same as the current user.
      '';
    };
    homeDirectory = mkOption {
      type = types.str;
      default = builtins.getEnv "HOME";
      example = "/home/myusername";
      description = ''
        The home directory of the user to manage.
        This is usually the same as the current user's home directory.
      '';
    };
  };

  config = mkIf cfg.enable {
    home = {
      inherit (cfg) username homeDirectory;
      # inherit username homeDirectory;
      stateVersion = "24.11";
    };
    home-manager-desktop-configuration.enable = cfg.desktopConfigEnable;
    # home-manager-desktop-configuration.homeDirectory = cfg.homeDirectory;

    programs = { htop.enable = true; };
  };
}
