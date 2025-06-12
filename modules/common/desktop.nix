{ config, lib, pkgs, ... }:

{
  # Desktop environment
  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      excludePackages = [ pkgs.xterm ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  security.rtkit.enable = true;

  # Exclude some packages from the GNOME environment
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.baobab
    pkgs.cheese
    pkgs.decibels
    pkgs.eog
    pkgs.epiphany
    pkgs.evince
    pkgs.gedit
    pkgs.file-roller
    pkgs.gnome-calculator
    pkgs.gnome-calendar
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-console
    pkgs.gnome-contacts
    pkgs.gnome-font-viewer
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    pkgs.gnome-photos
    pkgs.gnome-screenshot
    pkgs.gnome-system-monitor
    pkgs.gnome-tour
    pkgs.gnome-weather
    pkgs.gnome-disk-utility
    pkgs.gnome-connections
    pkgs.seahorse
    pkgs.simple-scan
    pkgs.snapshot
    pkgs.totem
    pkgs.yelp
    pkgs.geary
  ];

  documentation.nixos.enable = false;
}
