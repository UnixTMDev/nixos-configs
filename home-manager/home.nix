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
            syncthing
            vlc
        #    discord
        ];

        username = "unix";
        homeDirectory = "/home/unix";

        #Don't change this or something idk.
        stateVersion = "23.11";
    };
    xsession.windowManager.i3 = {
        enable = true;
        config = {
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
}
