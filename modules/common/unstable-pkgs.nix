{ config, lib, pkgs, ... }:

let
  unstableTarball = builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  unstable = import unstableTarball {
    config = { allowUnfree = true; };
    inherit (pkgs) system;
  };
in {
  options = {
    unstablePkgs = lib.mkOption {
      type = lib.types.attrs;
      description = "Unstable nixpkgs packages";
      default = { };
    };
  };

  config = { unstablePkgs = unstable; };
}
