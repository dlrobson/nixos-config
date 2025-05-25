{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "neebplgakaahbhdphmkckjjcegoiijjo"; } # Keepa
      { id = "idpbkophnbfijcnlffdmmppgnncgappc"; } # Rakuten
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
    ];
  };
}
