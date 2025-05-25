{ config, pkgs, ... }:

{
  imports = [ ../../common/unstable-pkgs.nix ];

  programs.alacritty.package = pkgs.unstable.alacritty;
}
