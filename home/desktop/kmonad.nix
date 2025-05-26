{ lib, pkgs, config, ... }:
with lib;
let
  isNixOS = builtins.pathExists "/etc/nixos";
in {
  config = mkIf (!isNixOS) {
    home.packages = with pkgs; [ kmonad ];

    home.file = { ".config/thinkpad.kbd".source = ../../assets/thinkpad.kbd; };

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
