{ config, pkgs, lib, ... }:

let
  homeDirectory = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
in {
  imports = [ ./home ];

  # Enable the home-manager configuration
  home-manager-configuration = {
    enable = true;
    desktopConfigEnable = true;
    username = username;
    homeDirectory = homeDirectory;
  };

  nixpkgs.config.allowUnfree = true;
}
