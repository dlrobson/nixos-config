{ config, lib, pkgs, ... }:

{
  # TODO(dan): Consider occasional pruning
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
