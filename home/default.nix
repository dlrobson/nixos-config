{ config, lib, pkgs, username, homeDirectory, ... }:

let
  isContainer = builtins.pathExists "/.dockerenv"
    || lib.pathExists "/run/.containerenv";

  isNixOS = builtins.pathExists "/etc/nixos";
  
  isGnome = config.services.xserver.desktopManager.gnome.enable or 
            (builtins.getEnv "XDG_CURRENT_DESKTOP" == "GNOME");
in {
  imports = [
    ./programs/git.nix
    ./programs/vim.nix
    ./programs/tmux.nix
    ./programs/bash.nix
    ./programs/fish.nix
  ] ++ lib.optionals (!isContainer) [
    ./programs/alacritty.nix
    ./programs/brave.nix
    ./programs/vscode.nix
  ] ++ lib.optional ((!isContainer) && (!isNixOS)) ./programs/kmonad.nix
    ++ lib.optional isGnome ./desktop/gnome.nix;

  programs.htop.enable = true;

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
