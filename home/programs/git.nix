{ config, pkgs, ... }:

{
  imports = [ ../../modules/common/unstable-pkgs.nix ];

  programs.git = {
    enable = true;
    userName = "Daniel Robson";
    userEmail = "danr.236@gmail.com";

    includes = [{
      condition = "hasconfig:remote.*.url:git@gitlab.com:ouster/*/**";
      contents = { user.email = "daniel.robson@ouster.io"; };
    }];

    extraConfig = {
      pull.rebase = true;
      core.editor = "vi";
      init.defaultBranch = "main";
    };
    difftastic = {
      enable = true;
      package = config.unstablePkgs.difftastic;
    };
  };
}
