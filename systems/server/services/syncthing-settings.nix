{ config, lib, pkgs, ... }:

let variables = import ../variables.nix;
in {
  # Syncthing configuration specific to laptop
  services.syncthing = {
    enable = true;
    user = "admin";
    dataDir = "/mnt/storage/data/sync-storage/";
    configDir = "/mnt/storage/data/sync-storage/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "0.0.0.0:8384"; # TODO(dan): Don't use all interfaces
    settings = {
      options = {
        globalAnnounceEnabled = false;
      };
      gui = {
        user = lib.optionalString (variables ? syncthing_gui_user)
          variables.syncthing_gui_user;
        password = lib.optionalString (variables ? syncthing_gui_password)
          variables.syncthing_gui_password;
      };
      devices = {
        "laptop" = { id = variables.syncthing_laptop_id; };
        "gill_laptop" = { id = variables.synthing_gill_laptop_id; };
      };
      folders = {
        "Gill and Dan Shared Folder" = {
          path = "/mnt/storage/data/sync-storage/gill-and-dan-shared";
          devices = [
            "laptop"
            "gill_laptop"
          ];
          id = "7vpz3-ngn9u";
        };
        "Dan files" = {
          path = "/mnt/storage/data/sync-storage/dan-files";
          devices = [
            "laptop"
          ];
          id = "rihg3-aiqta";
        };
        "Camera" = {
          path = "/mnt/storage/data/sync-storage/sm-g950w_nd8z-photos";
          devices = [
            "laptop"
          ];
          id = "sm-g950w_nd8z-photos";
        };
      };
    };
  };
}
