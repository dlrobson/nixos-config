{ config, lib, ... }:

{
  age = {
    identityPaths =
      [ "${config.users.users.robson.home}/.ssh/id_ed25519-agenix" ];
    secrets = {
      "passwords/laptop-robson".file =
        ../../../secrets/passwords/laptop-robson.age;
      "restic/env".file = ../../../secrets/restic/env.age;
      "restic/bucket".file = ../../../secrets/restic/bucket.age;
      "restic/password".file = ../../../secrets/restic/password.age;
    };
  };
}
