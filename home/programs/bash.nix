{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      if FISH_PATH="$(command -v fish)"; then
        SHELL="$FISH_PATH" exec "$FISH_PATH"
      fi
    '';
  };
}
