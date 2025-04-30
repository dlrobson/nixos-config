{ config, lib, pkgs, ... }:

{
  # Desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Exclude some packages from the GNOME environment
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.baobab
    pkgs.cheese
    pkgs.eog
    pkgs.epiphany
    pkgs.evince
    pkgs.gedit
    pkgs.file-roller
    pkgs.gnome-calculator
    pkgs.gnome-calendar
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.gnome-font-viewer
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    # gnome-photos
    pkgs.gnome-screenshot
    pkgs.gnome-system-monitor
    pkgs.gnome-tour
    pkgs.gnome-weather
    pkgs.gnome-disk-utility
    pkgs.gnome-connections
    pkgs.seahorse
    pkgs.simple-scan
    pkgs.totem
    pkgs.yelp
    pkgs.geary
  ];

  documentation.nixos.enable = false;
}
