{ config, lib, pkgs, ... }:

let cfg = config.customModules.services.homeManager;
in {
  options.customModules.services.homeManager = {
    enable = lib.mkEnableOption "Enable Home Manager configuration";

    username = lib.mkOption {
      type = lib.types.str;
      description = "Username for Home Manager";
    };

    homeDirectory = lib.mkOption {
      type = lib.types.str;
      description = "Home directory for the user";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      users.${cfg.username} = { config, lib, pkgs, ... }: {
        imports = [ ../../new-home ];

        # Enable the home manager configuration with the parameters from the module
        home-manager-configuration = {
          enable = true;
          username = cfg.username;
          homeDirectory = cfg.homeDirectory;
          desktopConfigEnable = true;
        };
      };
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
