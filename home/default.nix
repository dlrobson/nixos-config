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
      description = ''
        The username of the user to manage.
        This is usually the same as the current user.
      '';
    };
    homeDirectory = mkOption {
      type = types.str;
      description = ''
        The home directory of the user to manage.
        This is usually the same as the current user's home directory.
      '';
    };
  };

  config = mkIf cfg.enable {
    home = {
      inherit (cfg) username homeDirectory;
      stateVersion = "25.05";
    };
    home-manager-desktop-configuration.enable = cfg.desktopConfigEnable;
    home-manager-desktop-configuration.homeDirectory = cfg.homeDirectory;

    programs = { htop.enable = true; };
  };
}
