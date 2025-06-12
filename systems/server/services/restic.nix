{ config, lib, pkgs, ... }:

let
  # Common backup configuration
  commonBackupConfig = {
    initialize = true;
    environmentFile = config.age.secrets."restic/env".path;
    repositoryFile = config.age.secrets."restic/bucket".path;
    passwordFile = config.age.secrets."restic/password".path;
    pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
  };
in {
  services.restic.backups = {
    data = commonBackupConfig // { paths = [ "/mnt/storage/data" ]; };

    home = commonBackupConfig // {
      paths = [ "${config.users.users.admin.home}" ];
      exclude = [
        ".git"
        "target"
        "${config.users.users.admin.home}/.local/share/docker"
      ];
    };
  };
}
