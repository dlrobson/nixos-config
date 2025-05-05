{ config, lib, pkgs, ... }:

let
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  unstable = import unstableTarball {
    config = { allowUnfree = true; };
    inherit (pkgs) system;
  };
in {
  nixpkgs.overlays = [ (final: prev: { inherit unstable; }) ];
}
