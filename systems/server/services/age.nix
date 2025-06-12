{ config, lib, ... }:

{
  age = {
    identityPaths =
      [ "${config.users.users.admin.home}/.ssh/id_ed25519-agenix" ];
    secrets = {
      "forgejo/database-password".file =
        ../../../secrets/forgejo/database-password.age;
      "passwords/server-admin".file =
        ../../../secrets/passwords/server-admin.age;
      "restic/env".file = ../../../secrets/restic/env.age;
      "restic/bucket".file = ../../../secrets/restic/bucket.age;
      "restic/password".file = ../../../secrets/restic/password.age;
    };
  };
}
