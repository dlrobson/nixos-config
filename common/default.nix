{ config, lib, pkgs, ... }:

{
  imports = [ ./agenix.nix ./desktop.nix ./docker.nix ./system.nix ];

  nixpkgs.config.allowUnfree = true;
}
