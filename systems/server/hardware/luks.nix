{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = {
    "cryptkey" = {
      device = "/dev/disk/by-uuid/c93cada0-5b78-4922-8a18-bcec67432932";
      allowDiscards = true;
    };
    "cryptroot" = {
      device = "/dev/disk/by-uuid/40edc509-941a-4bbd-a436-86ec9703fc18";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "cryptroot2" = {
      device = "/dev/disk/by-uuid/cff14f08-0712-4811-a67e-3eae4f2f2fab";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthdda" = {
      device = "/dev/disk/by-uuid/0a36744b-7541-46cf-a697-1653f2024b3e";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthddb" = {
      device = "/dev/disk/by-uuid/c179bd70-1a65-43a7-a7bc-794ca558659a";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthddc" = {
      device = "/dev/disk/by-uuid/9cc8b846-d5df-4283-ad25-80141c6f09cf";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthddd" = {
      device = "/dev/disk/by-uuid/4f387ac5-fb24-44ec-bc3b-f68250ef11ce";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthdde" = {
      device = "/dev/disk/by-uuid/28d49dda-aa6c-4162-ad99-e7ab59660681";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
    "crypthddf" = {
      device = "/dev/disk/by-uuid/78465423-0c4d-4384-b3c7-68287c4336f9";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
      allowDiscards = true;
    };
  };

  environment.systemPackages = with pkgs;
    [
      tpm2-tss # To enable automated unlocking of LUKS root partition
    ];
}
