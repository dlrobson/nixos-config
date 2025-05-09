{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.unstable.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
      { id = "neebplgakaahbhdphmkckjjcegoiijjo"; } # Keepa
    ];
  };
}
