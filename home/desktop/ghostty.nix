{ config, pkgs, ... }:

let isNixOS = builtins.pathExists "/etc/nixos";
in {
  imports = [ ../../modules/common/unstable-pkgs.nix ./nixgl-pkgs.nix ];

  programs.ghostty = {
    package = if isNixOS then
      config.unstablePkgs.ghostty
    else
      config.lib.nixGL.wrap config.unstablePkgs.ghostty;

    settings = { theme = "dark:catppuccin-frappe,light:catppuccin-latte"; };
  };
}
