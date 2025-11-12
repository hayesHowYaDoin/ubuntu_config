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
      pop-shell
      workspace-indicator
      appindicator
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "just-perfection-desktop@just-perfection"
          "pop-shell@system76.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          "appindicatorsupport@rgcjonas.gmail.com"
        ];
      };

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

      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        active-hint = true;
        smart-gaps = true;
        gap-inner = 4;
        gap-outer = 4;
      };
    };
  };
}
