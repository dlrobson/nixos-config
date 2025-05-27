{ config, lib, pkgs, ... }:

# We sometimes may need to use NixGL on non-NixOS devices:
# https://github.com/nix-community/nixGL/issues/114#issuecomment-2741822320
let
  nixglTarball = builtins.fetchTarball
    "https://github.com/nix-community/nixGL/archive/main.tar.gz";
in { nixGL.packages = import nixglTarball { inherit pkgs; }; }
