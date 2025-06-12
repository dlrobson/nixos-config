{ config, pkgs, ... }:

{
  imports = [ ./bash.nix ./fish.nix ./git.nix ./rbw.nix ./tmux.nix ./vim.nix ];
}
