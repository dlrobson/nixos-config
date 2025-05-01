{ config, pkgs, lib, ... }:

{
  imports = [ ./home/default.nix ];

  # Pass necessary arguments to home/default.nix
  _module.args = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    isGnome = builtins.getEnv "XDG_CURRENT_DESKTOP" == "GNOME";
  };

  nixpkgs.config.allowUnfree = true;
}
