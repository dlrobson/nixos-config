{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    rootless.enable = true;
  };

  # The rootless Docker context is not added by default, so we add it manually.
  system.userActivationScripts.dockerRootlessContext = ''
    if ! ${pkgs.docker}/bin/docker context ls | grep -q "rootless"; then
      ${pkgs.docker}/bin/docker context create rootless --docker "host=unix://$XDG_RUNTIME_DIR/docker.sock" --description "Rootless Docker context"
    fi
  '';
}
