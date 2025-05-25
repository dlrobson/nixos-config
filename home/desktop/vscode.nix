{ config, pkgs, ... }:

{
  imports = [ ../../common/unstable-pkgs.nix ];

  programs.vscode.package = pkgs.unstable.vscode;
}
