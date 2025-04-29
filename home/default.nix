{ config, lib, pkgs, ... }:

let
  # Detect if running in a container
  isContainer = builtins.pathExists "/.dockerenv" || lib.pathExists "/run/.containerenv";
  
  # Detect if running on NixOS
  isNixOS = builtins.pathExists "/etc/nixos";
in
{
  imports = [
    ./programs/git.nix
    ./programs/vim.nix
    ./programs/tmux.nix
    ./programs/bash.nix
    ./programs/fish.nix
  ] 
  # Only import KMonad when not in a container and not on NixOS
  ++ lib.optional ((!isContainer) && (!isNixOS)) ./programs/kmonad.nix;

  # Common home-manager settings
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}