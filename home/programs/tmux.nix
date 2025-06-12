{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 100000;
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      cpu
      battery
      {
        plugin = yank;
        extraConfig = "set -g @yank_selection_mouse 'clipboard'";
      }
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
      {
        plugin = gruvbox;
        extraConfig = "set -g @tmux-gruvbox 'dark'";
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"

          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          set -agF status-right "#{E:@catppuccin_status_battery}"
        '';
      }
    ];
  };
}
