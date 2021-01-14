{ pkgs, ... }:

let
  dropString = n: str: builtins.substring n (builtins.stringLength str - n) str;
  transparent = color: "#BB${dropString 1 color}";

  nord = rec {
    nord0 = "#2E3440";
    nord1 = "#3B4252";
    nord2 = "#434C5E";
    nord3 = "#4C566A";
    nord4 = "#D8DEE9";
    nord5 = "#E5E9F0";
    nord6 = "#ECEFF4";
    nord7 = "#8FBCBB";
    nord8 = "#88C0D0";
    nord9 = "#81A1C1";
    nord10 = "#5E81AC";
    nord11 = "#BF616A";
    nord12 = "#D08770";
    nord13 = "#EBCB8B";
    nord14 = "#A3BE8C";
    nord15 = "#B48EAD";

    background = transparent nord0;
    foreground = nord4;
    buffer = nord3;

    urgent = nord11;
    warning = nord12;
    notify = nord13;
    success = nord14;
    function = nord15;
  };
in {
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3Support = true;
    };

    script = with pkgs; ''
      ${killall}/bin/killall -q polybar

      while ${procps}/bin/pgrep -x polybar >/dev/null; do
        sleep 1
      done

      for m in $(polybar --list-monitors | cut -d":" -f1); do
        MONITOR=$m polybar master &
      done
    '';

    config = {
      "bar/master" = {
        width = "100%";
        height = "3%";
        # separator = " ";
        padding-top = 1;
        padding-left = 2;
        padding-right = 2;
        radius = 0;
        override-redirect = true;
        wm-restack = "i3";
        inherit (nord)
          background
          foreground
          buffer
          urgent
          warning
          notify
          success
          function;
        font-0 = "Fira Mono:size=15;2";
        bottom = false;
        modules-left = "workspaces";
        modules-right = # "cpu memory temperature filesystem xkeyboard volume wireless-network consumption battery date";
          "date";
        tray-position = "right";
        tray-scale = 1;
      };
      "module/workspaces" = {
        type = "internal/i3";
        pin-workspaces = true;
        enable-click = true;
        enable-scroll = false;
        strip-wsnumbers = true;
        label-focused-padding = 1;
        label-focused-foreground = nord.nord9;
        label-focused-background = nord.nord6;
        label-unfocused-padding = 1;
        label-visible-padding = 1;
        label-urgent-padding = 1;
        label-urgent-background = nord.nord9;
        label-urgent-foreground = nord.nord6;
      };
      # "module/cpu" = {

      # };
      # "module/memory" = {

      # };
      # "module/temperature" = {

      # };
      # "module/filesystem" = {

      # };
      # "module/xkeyboard" = {

      # };
      # "module/volume" = {

      # };
      # "module/wireless-network" = {

      # };
      # "module/consumation" = {

      # };
      # "module/battery" = {

      # };
      # "module/backlight" = {
      #   type = "internal/backlight";
      #   format = "<label>";
      #   card =  "intel_backlight";
      #   label = "%percentage%%";
      #   ramp-0 = "";
      #   ramp-1 = "";
      #   ramp-2 = "";
      #   bar-width = 10;
      #   bar-indicator = "|";
      #   bar-indicator-font = 3;
      #   bar-indicator-foreground = "#ff";
      #   bar-fill = "─";
      #   bar-fill-font = 3;
      #   bar-fill-foreground = "#c9665e";
      #   bar-empty = "─";
      #   bar-empty-font = 3;
      #   bar-empty-foreground = "#44#";
      # };
      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%Y-%m-%d";
        time = "%H:%M:%S";
        label = "%date% %time%";
      };
    };
  };
}

