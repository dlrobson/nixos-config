{ config, lib, pkgs, ... }:

let variables = import ../../../secrets/variables.nix;
in {
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        ROOT_URL = "https://nixos-server.${variables.tailnet}/forgejo";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
      };
    };
    stateDir = "/mnt/storage/data/forgejo";
    database.passwordFile = config.age.secrets."forgejo/database-password".path;
  };
}
