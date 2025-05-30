{ config, pkgs, ... }:

{
  imports = [ ../../modules/common/unstable-pkgs.nix ];

  programs.vscode.package = pkgs.unstable.vscode;
}
