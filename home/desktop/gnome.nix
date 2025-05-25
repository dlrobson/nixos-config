{ config, lib, pkgs, ... }:

let
  hasDbus = builtins.pathExists "/etc/dbus-1/session.conf"
    || builtins.pathExists "/etc/dbus-1/session.d"
    || builtins.pathExists "/run/current-system/sw/share/dbus-1/session.conf";
in {
  dconf.settings = lib.mkIf hasDbus {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Primary><Alt>t";
        command = "alacritty";
        name = "open-terminal";
      };
  };
}
