{ config, lib, pkgs, ... }:

{
  age = {
    identityPaths = [ "${config.users.users.admin.home}/.ssh/id_ed25519" ];
    secrets = {
      "restic/env".file = ../../../secrets/restic/env.age;
      "restic/bucket".file = ../../../secrets/restic/bucket.age;
      "restic/password".file = ../../../secrets/restic/password.age;
    };
  };

  # TODO(dan): Notification on backup failure?
  services.restic.backups = {
    daily = {
      initialize = true;

      environmentFile = config.age.secrets."restic/env".path;
      repositoryFile = config.age.secrets."restic/bucket".path;
      passwordFile = config.age.secrets."restic/password".path;

      paths = [ "${config.users.users.admin.home}/dev" ];

      pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
    };
  };
}
