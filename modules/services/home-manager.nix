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
      users.${cfg.username} = import ../../home {
        inherit (cfg) username homeDirectory;
        inherit config pkgs lib;
      };
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
