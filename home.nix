{ config, pkgs, lib, ... }:

let
  homeDirectory = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
in {
  #   # This displays home-manager applications in the system tray
  # targets.genericLinux.enable = true;
  # xdg.mime.enable = true;
  # xdg.systemDirs.data = [ "${homeDirectory}/.nix-profile/share/applications" ];

  imports = [ ./proposed-home ];

  # Enable the home-manager configuration
  home-manager-configuration = {
    enable = true;
    desktopConfigEnable = true;
    username = username;
    homeDirectory = homeDirectory;
  };

  nixpkgs.config.allowUnfree = true;
}
