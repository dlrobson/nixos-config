{ config, lib, pkgs, username, homeDirectory, ... }:

let
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  unstable = import unstableTarball { config = { allowUnfree = true; }; };

  isContainer = builtins.pathExists "/.dockerenv"
    || lib.pathExists "/run/.containerenv";

  isNixOS = builtins.pathExists "/etc/nixos";
in {
  nixpkgs.overlays = [ (final: prev: { inherit unstable; }) ];

  imports = [
    ./programs/bash.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/rbw.nix
    ./programs/tmux.nix
    ./programs/vim.nix
  ] ++ lib.optionals (!isContainer) [
    ./desktop/gnome.nix
    ./programs/alacritty.nix
    ./programs/brave.nix
    ./programs/vscode.nix
  ] ++ lib.optional ((!isContainer) && (!isNixOS)) ./programs/kmonad.nix;

  programs = {
    home-manager.enable = true;
    htop.enable = true;
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
  };
}
