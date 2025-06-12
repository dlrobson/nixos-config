{ config, lib, pkgs, ... }:

{
  imports = [ ./age.nix ./forgejo.nix ./restic.nix ];
}
