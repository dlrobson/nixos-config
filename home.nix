{ config, pkgs, lib, ... }:

let
  homeDirectory = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
  desktopConfigEnable = builtins.getEnv "ENABLE_DESKTOP_CONFIG" != "";
in {
  imports = [ ./home ];

  home-manager-configuration = {
    enable = true;
    inherit desktopConfigEnable username homeDirectory;
  };

  nixpkgs.config.allowUnfree = true;
}
