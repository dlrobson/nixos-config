{ config, lib, pkgs, ... }:
let variables = import ../variables.nix;
in {
  imports = [
    ./hardware/hardware-configuration.nix
    ./hardware/luks.nix
    ./services/restic.nix
    ../../common
    ../../modules/services/home-manager.nix
    ../../modules/services/syncthing.nix
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  customModules.services = {
    homeManager = {
      enable = true;
      username = "admin";
      homeDirectory = "/home/admin";
    };
    syncthing = {
      enable = true;
      user = "admin";
      dataDir = "/mnt/storage/data/sync-storage/";
      configDir = "/mnt/storage/data/sync-storage/.config/syncthing";
      guiAddress = "0.0.0.0:8384";
      guiUser = lib.optionalString (variables ? syncthing_gui_user)
        variables.syncthing_gui_user;
      guiPassword = lib.optionalString (variables ? syncthing_gui_password)
        variables.syncthing_gui_password;
      devices = {
        "laptop" = { id = variables.syncthing_laptop_id; };
        "gill_laptop" = { id = variables.synthing_gill_laptop_id; };
      };
      folders = {
        gillAndDanShared = {
          enable = true;
          path = "/mnt/storage/data/sync-storage/gill-and-dan-shared";
          devices = [ "laptop" "gill_laptop" ];
        };
        danFiles = {
          enable = true;
          path = "/mnt/storage/data/sync-storage/dan-files";
          devices = [ "laptop" ];
        };
        camera = {
          enable = true;
          path = "/mnt/storage/data/sync-storage/sm-g950w_nd8z-photos";
          devices = [ "laptop" ];
        };
      };
      openFirewall = true;
    };
  };

  # TODO: Required for 5G ethernet. Remove once this is the default kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Use the systemd-boot EFI boot loader.
  networking = {
    hostId = "e3e68db8";
    hostName = "nixos-server";
  };

  # Disable GNOME3 auto-suspend feature
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIc+tZ6XSUqF/7g4IPQXWojEYfa2VI92MrZol7UZV4jd"
    ];
  };

  # Enabled services
  services = {
    openssh.enable = true;
    vscode-server.enable = true;
    tailscale.enable = true;
  };

  # Firewall configuration is now handled by the syncthing module
}
