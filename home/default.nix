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
    ./programs/git.nix
    ./programs/vim.nix
    ./programs/tmux.nix
    ./programs/bash.nix
    ./programs/fish.nix
  ] ++ lib.optionals (!isContainer) [
    ./programs/alacritty.nix
    ./programs/brave.nix
    ./desktop/gnome.nix
    ./programs/vscode.nix
  ] ++ lib.optional ((!isContainer) && (!isNixOS)) ./programs/kmonad.nix;

  programs.htop.enable = true;

  # TODO(dan): Not working as it is
  programs.rbw = {
    enable = true;
    settings.email = "danr.236@gmail.com";
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
