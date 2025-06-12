{ lib, pkgs, config, ... }:

{
  imports = [ ./home-manager.nix ./kmonad.nix ./syncthing.nix ];
}
