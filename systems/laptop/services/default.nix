{ config, lib, pkgs, ... }:

{
  imports = [ ./age.nix ./restic.nix ];
}
