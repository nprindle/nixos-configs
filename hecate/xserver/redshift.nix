{ ... }:

{
  location.provider = "geoclue2";
  services.localtime.enable = true;

  services.redshift = {
    enable = true;
    executable = "/bin/redshift-gtk";
    brightness = {
      day = "1";
      night = "0.6";
    };
    temperature = {
      day = 6500;
      night = 2700;
    };
  };
}
