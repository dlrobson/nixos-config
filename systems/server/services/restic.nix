{ config, lib, pkgs, ... }:

{
  # TODO(dan): Notification on backup failure?
  services.restic.backups = {
    daily = {
      initialize = true;

      environmentFile = config.age.secrets."restic/env".path;
      repositoryFile = config.age.secrets."restic/bucket".path;
      passwordFile = config.age.secrets."restic/password".path;

      # TODO(dan): Add the other paths
      paths = [ "${config.users.users.admin.home}/dev" ];

      pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
    };
  };
}
