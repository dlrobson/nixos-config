{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      {
        name = "plugin-git";
        inherit (pkgs.fishPlugins.plugin-git) src;
      }
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "z";
        inherit (pkgs.fishPlugins.z) src;
      }
      {
        name = "hydro";
        inherit (pkgs.fishPlugins.hydro) src;
      }
    ];

    functions = {
      clean_branches = ''
        git fetch --all --prune
        set branches_to_delete (git for-each-ref --format='%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)' refs/heads/ | string match -v ''')

        if test (count $branches_to_delete) -gt 0
          git branch -D $branches_to_delete
        else
          echo "No stale branches to clean up"
        end
      '';
    };
  };
}
