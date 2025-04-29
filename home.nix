{ config, pkgs, lib, ... }:

{
  imports = [ 
    (import ./home {
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
      inherit config pkgs lib;
    })
  ];
}
