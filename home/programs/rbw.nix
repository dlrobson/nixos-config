{ config, lib, pkgs, ... }:

{
  programs.rbw = {
    enable = true;
    package = pkgs.unstable.rbw;
    settings = {
      email = "danr.236@gmail.com";
      pinentry = pkgs.pinentry-gnome3;
    };
  };
}
