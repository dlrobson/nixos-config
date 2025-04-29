{ config, pkgs, lib, ... }:

{
  imports = [ ./home ];

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
}
