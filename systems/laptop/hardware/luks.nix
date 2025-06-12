{ config, lib, pkgs, ... }:

{
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

  # Package needed for automated unlocking of LUKS root partition
  environment.systemPackages = with pkgs; [ tpm2-tss ];
}
