{ config, lib, pkgs, ... }:

let shared = import ../shared/syncthing-folders.nix;
in {
  services.restic.backups = {
    home = {
      initialize = true;
      environmentFile = config.age.secrets."restic/env".path;
      repositoryFile = config.age.secrets."restic/bucket".path;
      passwordFile = config.age.secrets."restic/password".path;
      pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
      paths = [ "${config.users.users.robson.home}" ];
      exclude = [
        ".git"
        "target"
        "${config.users.users.robson.home}/.local/share/docker"
      ] ++ (lib.attrValues shared.syncthingFolders);
    };
  };
}
