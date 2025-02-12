{ lib, pkgs, ... }:
let
    mod = "Mod4";
in {
    home = {
        packages = with pkgs; [
            # Pentesting
            wireshark
            nmap
            tcpdump
            netcat
            gcc
            gdb
            strace

            # Desktop stuff
            vscodium
            firefox
            tailscale
            ktailctl
            syncthing
            vlc
            discord

            tmux
            prismlauncher
        ];

        username = "unix";
        homeDirectory = "/home/unix";

        #Don't change this or something idk.
        stateVersion = "23.11";
    };

    xsession.windowManager.i3 = {
        enable = true;
        extraConfig = ''
        workspace "1" output DP-0
        workspace "2" output DP-2
        '';
        config = {
            startup = [
                # { command = "/home/unix/displays.sh"; }
                { command = "xrandr --output DP-0 --left-of DP-2"; notification = false; }
            ];
            modifier = mod;
            keybindings = lib.mkOptionDefault {
                "${mod}+t" = "exec ${pkgs.firefox}/bin/firefox";
                # Focus
                "${mod}+j" = "focus left";
                "${mod}+k" = "focus down";
                "${mod}+l" = "focus up";
                "${mod}+semicolon" = "focus right";
                # Move
                "${mod}+Shift+j" = "move left";
                "${mod}+Shift+k" = "move down";
                "${mod}+Shift+l" = "move up";
                "${mod}+Shift+semicolon" = "move right";
            };
        };
    };

    programs.kitty = {
        enable = true;
        font = {
            package = pkgs.dejavu_fonts;
            size = 20;
            name = "DejaVu Sans";
        };
    };

    programs.i3status.modules = {
      "ethernet eth0" = {
          position = 1;
          settings = {
              format_up = "E: %ip (%speed)";
              format_down = "E: down";
          };
      };
      "volume master" = {
          position = 9;
          settings = {
            format = "♪ %volume";
            format_muted = "♪ muted (%volume)";
            device = "pulse";
          };
      };
      "disk /" = {
          position = 2;
          settings = {
            format = "ROOT: %avail (%percentage_avail)";
          };
      };
      "cpu_usage" = {
          position = 3;
          settings = {
              format = "CPU: %usage"
          };
      };
      "memory" = {
          position = 4;
          settings = {
              format = "RAM: %used/%total (%used)"
          };
      };
      "tztime local" = {
          position = 10;
          settings = {
              format = "%Y-%m-%d %H:%M:%S"
          };
      };
    };

    programs.tmux = {
        enable = true;
        clock24 = true;
        prefix = "C-space";
    };
}
