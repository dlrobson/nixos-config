{ config, pkgs, ... }:

let isNixOS = builtins.pathExists "/etc/nixos";
in {
  imports = [ ../../common/unstable-pkgs.nix ../../common/nixgl-pkgs.nix ];

  programs.alacritty.package = if isNixOS then
    pkgs.unstable.alacritty
  else
    config.lib.nixGL.wrap pkgs.unstable.alacritty;
}
