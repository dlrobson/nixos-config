{ config, pkgs, ... }:

{
  programs.chromium = {
    package = pkgs.unstable.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "neebplgakaahbhdphmkckjjcegoiijjo"; } # Keepa
      { id = "idpbkophnbfijcnlffdmmppgnncgappc"; } # Rakuten
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
    ];
  };
}
