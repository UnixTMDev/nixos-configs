{ lib, pkgs, ... }:
let
    mod = "Mod4";
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
    };

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
            tailscale
            ktailctl
            insomnia
            syncthing
            vlc
            discord
            prusa-slicer
            super-slicer

            unityhub

            tmux
            prismlauncher
            playerctl
            pulseaudio
            wmctrl
            
            ffmpeg
            aegisub

            melonDS # Love DS emulation tbh
        ];

        username = "unix";
        homeDirectory = "/home/unix";

        #Don't change this or something idk.
        stateVersion = "23.11";
    };

    xresources = {
        properties = {
            "Xcursor.size" = 38;
        };
    };

    xsession.windowManager.i3 = {
        enable = true;
        extraConfig = ''
        workspace "1" output DP-0
        workspace "2" output DP-2
  '';
#        assign [class="discord"] "3"
#        assign [class="steam"] "3"
#        '';
        config = {
            startup = [
                { command = "~/nixos-configs/home-manager/firefox_login.sh"; } # It's Firefox, why wouldn't I want it on startup?
                { command = "${pkgs.discord}/bin/discord"; } # I *do* have friends, contrary to how it seems.
                { command = "~/nixos-configs/home-manager/noisetorch.sh"; } # Comedy or something.
                { command = "${pkgs.steam}/bin/steam"; } # Funny joke about Helldivers 2 here.

                { command = "${pkgs.xbindkeys}/bin/xbindkeys"; } # Muos buton :)
                { command = "${pkgs.solaar}/bin/solaar"; } # Muos buton :)
                { command = "~/code/terminator/run.sh"; } # I like to look at btop on my other monitor.

                # WM stuff
                { command = "${pkgs.feh}/bin/feh --no-fehbg --bg-scale /home/unix/helldivers.png"; }
                { command = "xrandr --output DP-0 --left-of DP-2"; notification = false; }
                { command = "setxkbmap -option compose:caps"; notification = false; }
            ];
            modifier = mod;
            keybindings = lib.mkOptionDefault {
                #XF86AudioRaiseVolume/XF86AudioLowerVolume
                "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
                "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
                "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
                "XF86AudioPlay" = "exec playerctl -a play-pause";
                "XF86AudioPrev" = "exec playerctl -a previous";
                "XF86AudioNext" = "exec playerctl -a next";
                "${mod}+t" = "exec ${unstable.firefox}/bin/firefox";
                "${mod}+g" = "exec /home/unix/dmenu_with_output.sh";
                "${mod}+BackSpace" = "exec /home/unix/nixos-configs/home-manager/kill_py.sh";
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
        extraConfig = "confirm_os_window_close 0\npaste_actions replace-dangerous-control-codes";
    };

    programs.vim = {
        enable = true;
        defaultEditor = true;
        settings = {
            tabstop = 4;
            shiftwidth = 4;
            number = true;
            mouse = "a";
        };
    };
    
    programs.i3status = {
        enable = true;
        enableDefault = false;
        general = {
            colors = true;
            color_good = "#38f561";
            color_degraded = "#f5d938";
            color_bad = "#c71e18";
            interval = 1;
        };
        modules = {
          "ethernet _first_" = {
              position = 1;
              settings = {
                  format_up = "E: %ip (%speed)";
                  format_down = "E: down";
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
                  format = "CPU: %usage";
              };
          };
          "memory" = {
              position = 4;
              settings = {
                  format = "RAM: %used/%total (%percentage_used)";
              };
          };
          "tztime local" = {
              position = 5;
              settings = {
                  format = "%Y-%m-%d %H:%M:%S";
              };
          };
          "volume master" = {
              position = 6;
              settings = {
                format = "♪ %volume";
                format_muted = "♪ muted (%volume)";
                device = "pulse";
              };
          };
        };
    };

    programs.tmux = {
        enable = true;
        clock24 = true;
        prefix = "C-space";
    };
}
