{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
    ];
    
    functions = {
      clean_branches = ''
        git fetch --all --prune && git branch -D (git branch -vv | string match -r ': gone]' | string match -rv '\*' | awk '{ print $1; }')
      '';
    };
  };
}