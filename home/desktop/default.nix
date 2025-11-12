{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.gnome;
in {
  imports = [./fonts.nix ./ghostty.nix];

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
    home.packages = with pkgs.gnomeExtensions; [
      just-perfection
    ];

    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = builtins.toString cfg.background;
        picture-uri-dark = builtins.toString cfg.backgroundDark;
      };
      "org/gnome/shell/extensions/just-perfection" = {
        dash = false; # Hide the dash/sidebar
        workspace-switcher-should-show = true;
        panel = true; # Keep top bar
        activities-button = false; # Optional: hide Activities button
      };
    };
  };
}
