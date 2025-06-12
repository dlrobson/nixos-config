{ config, lib, pkgs, ... }:

let isNixOS = builtins.pathExists "/etc/nixos";
in {
  imports = [ ./nixgl-pkgs.nix ];

  programs.chromium = {
    package = if isNixOS then pkgs.brave else config.lib.nixGL.wrap pkgs.brave;

    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "neebplgakaahbhdphmkckjjcegoiijjo"; } # Keepa
      { id = "idpbkophnbfijcnlffdmmppgnncgappc"; } # Rakuten
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
    ];
  };
}
