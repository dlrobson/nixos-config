{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
      { id = "neebplgakaahbhdphmkckjjcegoiijjo"; } # Keepa
    ];
  };
}
