{ config, pkgs, ... }:

{
  imports = [ ../../modules/common/unstable-pkgs.nix ];

  programs.vscode.package = config.unstablePkgs.vscode;
}
