# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = { allowUnfree = true; }; };
  variables = import ./variables.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    # (unstableTarball + "/nixos/modules/services/desktop-managers/cosmic.nix")
    # (unstableTarball + "/nixos/modules/services/display-managers/cosmic-greeter.nix")
  ];

  # Enable the COSMIC Desktop Environment from unstable
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices = {
    "cryptkey" = {
      device = "/dev/disk/by-uuid/0b11b739-1461-4054-b6d6-ae660ecccc52";
      allowDiscards = true;
    };
    "cryptroot" = {
      device = "/dev/disk/by-uuid/bf7dd485-803e-4267-b349-86385e283fbd";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
  };

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  networking.hostName = "nixos-laptop";

  # TODO: Enable wireless?
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;	
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.robson = {
    isNormalUser = true;
    description = "robson";
    extraGroups = [
      "networkmanager"
      "wheel"
      # Kmonad Requirements
      "input"
      "uinput"
    ];
    packages = with pkgs; [
      brave
      vscode
      alacritty
      htop
      git
      libreoffice-qt
      slack
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 
  environment.systemPackages = with pkgs; [
    tpm2-tss # To enable automated unlocking of LUKS root partition
  ];

  services.tailscale.enable = true;
  services.kmonad = {
   enable = true;
   keyboards = {
     builtinKeyboard = { 
       device = "/dev/input/event0";
       # Using the dotfiles variable from variables.nix
       config = builtins.readFile "${variables.dotfiles}/kmonad/thinkpad.kbd";
     };
   };
  };
  services.syncthing = {
    enable = true;
    user = "robson";
    dataDir = "/home/robson/Documents";
    configDir = "/home/robson/Documents/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      gui = {
        user = variables.syncthing_gui_user;
        password = variables.syncthing_gui_password;
      };
      devices = {
        "server" = {
          id = variables.syncthing_server_id;
        };
      };
      folders = {
        "Gill and Dan Shared Folder" = {
          path = "/home/robson/Documents/gill-and-dan-shared";
          devices = [ "server" ];
          id = "7vpz3-ngn9u";
        };
        "Dan files" = {
          path = "/home/robson/Documents/dan-files";
          devices = [ "server" ];
          id = "rihg3-aiqta";
        };
        "Camera" = {
          path = "/home/robson/Pictures/sm-g950w_nd8z-photos";
          devices = [ "server" ];
          id = "sm-g950w_nd8z-photos";
        };
      };
    };
  };

  system.stateVersion = "24.11";
}
