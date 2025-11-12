{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.gnome;
in {
  options.features.desktop.gnome = {
    enable = mkEnableOption "Enable gnome configuration.";
    background = mkOption {
      type = types.path;
      example = ../assets/wallpaper.jpeg;
      description = "Set desktop wallpaper.";
    };
    backgroundDark = mkOption {
      type = types.path;
      example = ../assets/wallpaperDark.jpeg;
      description = "Set desktop dark wallpaper.";
    };
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = builtins.toString cfg.background;
        picture-uri-dark = builtins.toString cfg.backgroundDark;
      };
    };
  };
}
