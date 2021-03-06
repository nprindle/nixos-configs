{ pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./picom.nix
    ./logind.nix
    ./redshift.nix
  ];

  environment.systemPackages = with pkgs; [
    xorg.xev
    xorg.xmodmap
    xorg.xdpyinfo
    xdotool
  ];

  services.xserver = {
    enable = true;

    # Enable touchpad
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    layout = "us";
    xkbVariant = "dvp";
    xkbOptions = "caps:escape,compose:ralt";

    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;

          clock-format = "%I:%M %p";

          theme = {
            name = "Materia-dark";
            package = pkgs.materia-theme;
          };

          iconTheme = {
            name = "Papirus-Adapta-Nokto";
            package = pkgs.papirus-icon-theme;
          };
        };

        background = ../../desktop-backgrounds/alien-moon.png;
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      configFile = ./i3/i3config;

      # Set the desktop background to the current cached lock screen
      # TODO: consider using `feh --no-fehbg --bg-fill --randomize ../../desktop-backgrounds/*.png`
      # (or find a way to randomize betterlockscreen backgrounds)
      extraSessionCommands = ''
        ${pkgs.betterlockscreen}/bin/betterlockscreen -w
      '';

      extraPackages = with pkgs; [
        # Menu/launcher
        rofi
        # Status bar
        i3status
        # Lock screen
        i3lock betterlockscreen
        # Applets
        networkmanagerapplet
        blueman
        mate.mate-media
        # Media controls (pactl is provided by pulseaudio)
        playerctl
      ];
    };

  };

  programs = {
    nm-applet.enable = true;
  };
}
