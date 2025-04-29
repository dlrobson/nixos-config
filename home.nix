{ config, pkgs, lib, ... }@args:

let
  user = args.username or (builtins.getEnv "USER");
  home = args.homeDirectory or (builtins.getEnv "HOME");
in
{
  imports = [ ./home ];

  home.username = user;
  home.homeDirectory = home;
}