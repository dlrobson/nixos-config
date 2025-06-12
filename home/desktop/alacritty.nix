{ config, pkgs, ... }:

let isNixOS = builtins.pathExists "/etc/nixos";
in {
  imports = [ ../../modules/common/unstable-pkgs.nix ./nixgl-pkgs.nix ];

  programs.alacritty.package = if isNixOS then
    config.unstablePkgs.alacritty
  else
    config.lib.nixGL.wrap config.unstablePkgs.alacritty;
}
