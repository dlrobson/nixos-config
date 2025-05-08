{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    # TODO(dan): Consider occasional pruning. This may not apply to rootless containers.
    autoPrune.enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
