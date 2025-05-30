{ config, lib, pkgs, ... }:

# TODO(dan): This is in the common folder, however is not imported by the
# default.nix file. This is only used for the home directory. Perhaps it
# should be moved there instead.

# We sometimes may need to use NixGL on non-NixOS devices:
# https://github.com/nix-community/nixGL/issues/114#issuecomment-2741822320
let
  nixglTarball = builtins.fetchTarball
    "https://github.com/nix-community/nixGL/archive/main.tar.gz";
in { nixGL.packages = import nixglTarball { inherit pkgs; }; }
