{ config, lib, pkgs, ... }:

{
  imports = [ ./system.nix ./desktop.nix ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
