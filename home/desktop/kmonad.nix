{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.kmonad-configuration;
  isNixOS = builtins.pathExists "/etc/nixos";
in {
  options.kmonad-configuration = {
    enable =
      mkEnableOption "Enable KMonad configuration. Not intended for NixOS.";
  };

  config = mkIf (cfg.enable && !isNixOS) {
    # Install KMonad package
    home.packages = with pkgs; [ kmonad ];

    home.file = { ".config/thinkpad.kbd".source = ./kmonad/thinkpad.kbd; };

    systemd.user.services.kmonad-mapping = {
      Unit = { Description = "Start KMonad with custom mapping"; };
      Service = {
        ExecStart = "${pkgs.kmonad}/bin/kmonad %h/.config/thinkpad.kbd";
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
