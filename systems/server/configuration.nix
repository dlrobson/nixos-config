{ config, lib, pkgs, ... }:
let variables = import ../variables.nix;
in {
  imports = [
    ./hardware/hardware-configuration.nix
    ./hardware/luks.nix
    ./services
    ../../modules
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  customModules.services = {
    homeManager = {
      enable = true;
      users = {
        admin = { desktopEnable = true; };
        service-user = { desktopEnable = false; };
      };
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

  users.users = {
    admin = {
      isNormalUser = true;
      description = "admin";
      linger = true;
      hashedPasswordFile = config.age.secrets."passwords/server-admin".path;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIc+tZ6XSUqF/7g4IPQXWojEYfa2VI92MrZol7UZV4jd"
      ];
    };
    service-user = {
      isNormalUser = true;
      description = "service-user";
      linger = true;
      subUidRanges = [{
        count = 65534;
        startUid = 100000;
      }];
      subGidRanges = [{
        count = 65534;
        startGid = 100000;
      }];
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIc+tZ6XSUqF/7g4IPQXWojEYfa2VI92MrZol7UZV4jd"
      ];
    };
  };

  home-manager.users.service-user.systemd.user = {
    services.start-docker-services = {
      Unit = {
        Description = "Pull and Start Docker services";
        After = [ "docker.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.docker}/bin/docker --context rootless compose --profile '*' --project-directory ${variables.docker_compose_project_dir} up -d
          ${pkgs.docker}/bin/docker --context rootless image prune -f
        '';
      };
    };

    timers.start-docker-services = {
      Timer = {
        # Sometimes the `depends_on` option doesn't work after a reboot.
        OnBootSec = "30s";
        OnCalendar = "Sat *-*-* 03:00:00";
        Persistent = true;
        Unit = "start-docker-services.service";
      };
    };
  };

  services = {
    openssh.enable = true;
    vscode-server.enable = true;
    tailscale.enable = true;
  };
}
