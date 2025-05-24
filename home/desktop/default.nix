{ lib, pkgs, config, ... }:
with lib;
let cfg = config.home-manager-desktop-configuration;
in {
  imports = [ ./alacritty.nix ./brave.nix ./vscode.nix ];
  # imports = [ ./alacritty.nix ./brave.nix ./kmonad.nix ./vscode.nix ];

  options.home-manager-desktop-configuration = {
    enable = mkEnableOption "Enable home-manager desktop configuration";
  };

  config = mkIf cfg.enable {
    programs.alacritty.enable = true;
    programs.chromium.enable = true; # brave
    programs.vscode.enable = true;
    kmonad-configuration.enable = true;
  };
}
