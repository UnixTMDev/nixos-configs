{ config, pkgs, lib, ... }:

{
      imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    # Set hostname
    networking.hostName = "unix-nixos";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your system timezone
    time.timeZone = "America/Los_Angeles";  # Change this to your timezone

    # Enable the OpenSSH daemon
    services.openssh.enable = true;

    # Define a user
    users.users.unix = {
      isNormalUser = true;
      description = "UnixTMDev";
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      password = "password"; # Change after login
    };

    environment.sessionVariables = rec {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";

      # Not officially in the specification
      XDG_BIN_HOME    = "$HOME/.local/bin";
      PATH = [ 
        "${XDG_BIN_HOME}"
      ];
      TERMINAL = "${pkgs.kitty}/bin/kitty";
    };

    environment.systemPackages = with pkgs; [
      home-manager

      python3
      python3-pip
    # CLI tools
      vim
      git
      wget
      curl
      htop
      neofetch
      btop
      unzip
      zip
      file
      fish
      bash
      zsh

      #UI
      i3 # The WM itself
      i3status # Status bar
      i3lock # Lock screen
      dmenu # Application launcher
      feh # For setting wallpapers
      picom # Compositor for transparency/effects
      lxappearance # GTK theme config
      pavucontrol # Audio control (because you *will* need it)
      xorg.xrandr # Display settings
      kitty
    ];

    programs.nix-ld.enable = true;

    programs.nix-ld.libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];

    # Leave commented out until baremetal is used. Please.
    #services.xserver.videoDrivers = [ "nvidia" ];
    #hardware.nvidia = {
    #  modesetting.enable = true;
    #  powerManagement.enable = true;
    #  open = false; # Change to true if you want the open-source driver
    #  nvidiaSettings = true; # Installs the NVIDIA settings GUI
    #};

    networking.firewall.enable = false;

    # Enable the Nix daemon for multi-user support
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Allow unfree packages (e.g., proprietary stuff like NVIDIA drivers)
    nixpkgs.config.allowUnfree = true;

    # Configure the bootloader (Grub, by default)
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda"; # Change before baremetal time

    hardware.pulseaudio.enable = false;

    # Enable X11 and i3
    services.xserver.enable = true;
    services.xserver.dpi = 200;
    services.xserver.windowManager.i3.enable = true;

    # Set a login manager (lightdm works well with i3)
    services.xserver.displayManager.lightdm.enable = true;
    services.displayManager.defaultSession = "none+i3";

    # System-wide shell
    environment.shells = with pkgs; [ bash zsh fish ];

    # Apply changes
    system.stateVersion = "23.11"; # Change this to match your NixOS install version

    # "Gaming Stuff (Because You Will Eventually Do It)"
    programs.steam.enable = true;
    hardware.graphics.enable = true;
    programs.fish.enable = true;

}
