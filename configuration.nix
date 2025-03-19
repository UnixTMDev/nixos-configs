{ config, pkgs, lib, ... }:

let
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
      imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];
    # Set hostname
    networking.hostName = "unix-nixos";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your system timezone
    time.timeZone = "America/Los_Angeles";
    
    # Enable the OpenSSH daemon
    services.openssh.enable = true;
    services.openssh.forwardX11 = true;



    # Define a user
    users.users.unix = {
      isNormalUser = true;
      description = "UnixTMDev";
      extraGroups = [ "wheel" "dialout" "syncthing" ]; # augh
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
      ollama
      zulu23
      unstable.firefox
      tk
      dotnet-sdk
      wine
      scrcpy
      playwright-driver
      playwright-driver.browsers
      winetricks
      mono
      numlockx
      logitech-udev-rules
      websocat
      gcc
      lime3ds
      input-remapper
      pciutils
      xautomation
      xdotool
      lsof
      solaar
      cl-wordle
      xclip
      weather
      xbindkeys
      xorg.libxcb
      noisetorch

      android-tools
      android-studio

      lynx
      portaudio
      espeak

      flitter

      gnumake

      weechat
      icu
      iamb

      home-manager
      rustdesk
      alsa-utils
      gnupg
      zlib
      openssl_3
      inetutils

      python312Packages.numpy
      python312Packages.tkinter

      monero-cli
      xmrig
      p2pool

      usbutils
      minicom
      dunst
      p7zip

      python3
      python312Packages.pip
    # CLI tools
      vim
      git
      gh
      wget
      curl
      htop
      neofetch
      btop
      unzip
      zip
      killall
      file
      fish
      bash
      zsh
      nix-index

      #UI
      i3 # The WM itself
      i3status # Status bar
      i3lock # Lock screen
      dmenu # Application launcher
      feh # For setting wallpapers
      picom # Compositor for transparency/effects
      lxappearance # GTK theme config
      pulsemixer
      xorg.xrandr # Display settings
      xorg.xev
      xorg.setxkbmap
      feh # For wallpaper stuff
      kitty

      gimp
      arduino-ide

      flatpak

      obs-studio


      fuse3
      appimage-run

      virt-manager
      qdirstat
      blender
    ];

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false; # "wah wah its insecure" don't care. convenience baby
    };

    #fileSystems."/mnt/windows" =
    #{ device = "/dev/disk/by-uuid/56B68CF1B68CD343";
    #  fsType = "ntfs";
    #  options = [ "umask=0000" "exec" "uid=1000" ];
    #};

    fileSystems."/mnt/nvme" =
    { device = "/dev/disk/by-uuid/2C9E6B849E6B4604";
      fsType = "ntfs";
      options = [ "umask=0000" "exec" "uid=1000" ];
    };
    hardware.logitech.wireless.enable = true;

    services.ollama.enable = true;
    services.ollama.acceleration = "cuda";

    services.input-remapper.enable = true;

    virtualisation.libvirtd.enable = false;
    users.groups.libvirtd.members = ["unix"];
    virtualisation.spiceUSBRedirection.enable = false;

    services.monero.enable = false;
    services.monero.mining.enable = false;
    services.monero.extraConfig = ''zmq-pub=tcp://127.0.0.1:18083
      out-peers=16
      in-peers=32
      disable-dns-checkpoints=true
      enable-dns-blocklist=true
    '';
    services.monero.priorityNodes = [ "p2pmd.xmrvsbeast.com:18080" "nodes.hashvault.pro:18080" ];

    services.tailscale.enable = true;
    services.flatpak.enable = true;
    services.syncthing.enable = true;

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

    xdg.portal.enable = true;

    programs.nix-ld.enable = true;

    programs.nix-ld.libraries = with pkgs; [
      portaudio
      icu
      ninja
      i3
      meson
      pkg-config
      xorg.libxcb
      hidapi
      libusb1
      opencv
      libjpeg
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];

    # Leave commented out until baremetal is used. Please.
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false; # Change to true if you want the open-source driver
      nvidiaSettings = true; # Installs the NVIDIA settings GUI
    };

    networking.firewall.enable = false;

    # Enable the Nix daemon for multi-user support
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Allow unfree packages (e.g., proprietary stuff like NVIDIA drivers)
    nixpkgs.config.allowUnfree = true;

    # Configure the bootloader (Grub, by default)
    boot.loader.systemd-boot.enable = true;

    hardware.pulseaudio.enable = false;

    # Enable X11 and i3
    services.xserver.enable = true;
    services.xserver.dpi = 175;
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


    services.speechd.enable = true;

}
