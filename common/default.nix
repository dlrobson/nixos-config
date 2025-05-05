{ config, lib, pkgs, ... }:

{
  imports = [ ./desktop.nix ./docker.nix ./system.nix ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
