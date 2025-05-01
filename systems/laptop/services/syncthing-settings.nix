{ config, lib, pkgs, ... }:

let variables = import ../variables.nix;
in {
  # Syncthing configuration specific to laptop
  services.syncthing = {
    enable = true;
    user = "robson";
    dataDir = "/home/robson/Documents";
    configDir = "/home/robson/Documents/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      gui = {
        user = lib.optionalString (variables ? syncthing_gui_user)
          variables.syncthing_gui_user;
        password = lib.optionalString (variables ? syncthing_gui_password)
          variables.syncthing_gui_password;
      };
      devices = { "server" = { id = variables.syncthing_server_id; }; };
      folders = {
        "Gill and Dan Shared Folder" = {
          path = "/home/robson/Documents/gill-and-dan-shared";
          devices = [ "server" ];
          id = "7vpz3-ngn9u";
        };
        "Dan files" = {
          path = "/home/robson/Documents/dan-files";
          devices = [ "server" ];
          id = "rihg3-aiqta";
        };
        "Camera" = {
          path = "/home/robson/Pictures/sm-g950w_nd8z-photos";
          devices = [ "server" ];
          id = "sm-g950w_nd8z-photos";
        };
      };
    };
  };
}
