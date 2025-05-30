{ config, lib, pkgs, ... }:

{
  imports = [
    ./agenix.nix
    ./desktop.nix
    ./docker.nix
    ./system.nix
    ./unstable-pkgs.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
