{ config, lib, pkgs, ... }:

let cfg = config.customModules.services.homeManager;
in {
  options.customModules.services.homeManager = {
    enable = lib.mkEnableOption "Enable Home Manager configuration";

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          desktopEnable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable desktop configuration for this user";
          };
        };
      });
      description = "Attribute set of users with their configuration options";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      users = lib.mapAttrs (username: userConfig:
        { config, lib, pkgs, ... }: {
          imports = [ ../../home ];

          home-manager-configuration = {
            enable = true;
            desktopConfigEnable = userConfig.desktopEnable;
            homeDirectory = "/home/${username}";
            inherit username;
          };
        }) cfg.users;
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
