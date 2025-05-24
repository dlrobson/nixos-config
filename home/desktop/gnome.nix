{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.gnome-configuration;

  hasDbus = builtins.pathExists "/etc/dbus-1/session.conf"
    || builtins.pathExists "/run/current-system/sw/share/dbus-1/session.conf";

  isNixOS = builtins.pathExists "/etc/nixos";
in {
  imports = [ ];

  options.gnome-configuration = {
    enable = mkEnableOption "Whether to enable the GNOME configuration";
    homeDirectory = mkOption {
      type = types.str;
      description = "The home directory of the user.";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
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
    })

    # This displays home-manager applications on non-NixOS systems
    (mkIf (cfg.enable && !isNixOS) {
      targets.genericLinux.enable = true;
      xdg.mime.enable = true;
      xdg.systemDirs.data =
        [ "${cfg.homeDirectory}/.nix-profile/share/applications" ];
    })
  ];
}
