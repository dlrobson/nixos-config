{ config, pkgs, lib, username ? null, homeDirectory ? null, ... }:

let
  # Use provided username/homeDirectory if specified, otherwise use environment variables
  user = if username != null then username else builtins.getEnv "USER";
  home = if homeDirectory != null then homeDirectory else builtins.getEnv "HOME";
in
{
  # Import the common home configuration
  imports = [ ./home ];

  # Set the username and home directory
  home.username = user;
  home.homeDirectory = home;
}