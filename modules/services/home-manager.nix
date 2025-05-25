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
        imports = [ ../../home ];

        home-manager-configuration = {
          enable = true;
          desktopConfigEnable = true;
          inherit (cfg) homeDirectory username;
        };
      };
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
