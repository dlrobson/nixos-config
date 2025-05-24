{ lib, pkgs, config, ... }:
with lib;
let cfg = config.home-manager-desktop-configuration;
in {
  imports =
    [ ./alacritty.nix ./brave.nix ./gnome.nix ./kmonad.nix ./vscode.nix ];

  options.home-manager-desktop-configuration = {
    enable = mkEnableOption "Enable home-manager desktop configuration";
    homeDirectory = mkOption {
      type = types.str;
      description = "The home directory of the user.";
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty.enable = true;
    programs.chromium.enable = true; # brave
    programs.vscode.enable = true;
  };
}
