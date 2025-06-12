{ config, lib, pkgs, ... }:

let
  agenixRepo = builtins.fetchTarball
    "https://github.com/ryantm/agenix/archive/main.tar.gz";
in {
  imports = [ "${agenixRepo}/modules/age.nix" ];

  environment.systemPackages =
    [ (pkgs.callPackage "${agenixRepo}/pkgs/agenix.nix" { }) ];
}
