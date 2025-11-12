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
      appindicator
      vitals
      pop-shell
      workspace-matrix
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "just-perfection-desktop@just-perfection"
          "pop-shell@system76.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "Vitals@CoreCoding.com"
          "wsmatrix@martin.zurowietz.de"
        ];
      };

      "org/gnome/desktop/background" = {
        picture-uri = builtins.toString cfg.background;
        picture-uri-dark = builtins.toString cfg.backgroundDark;
      };

      "org/gnome/mutter" = {
        overlay-key = "Super_L";
        workspaces-only-on-primary = false;
      };

      "org/gnome/shell/extensions/just-perfection" = {
        dash = false; # Dash/sidebar
        workspace-switcher-should-show = true;
        workspace-popup = true;
        panel = true; # Top bar
        activities-button = false;
        app-menu = false;
      };

      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        active-hint = true;
        active-hint-border-radius = 4;
        smart-gaps = true;
        gap-inner = 4;
        gap-outer = 4;
        show-title = false;
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-left = ["<Super><Control>Left"];
        switch-to-workspace-right = ["<Super><Control>Right"];
        switch-to-workspace-up = ["<Super><Control>Up"];
        switch-to-workspace-down = ["<Super><Control>Down"];
      };

      "org/gnome/shell/extensions/wsmatrix-keybindings" = {
        workspace-overview-toggle = ["<Super>w"];
        workspace-overview-right = ["Right"];
        workspace-overview-left = ["Left"];
        workspace-overview-up = ["Up"];
        workspace-overview-down = ["Down"];
        workspace-overview-confirm = ["Return" "Escape"];
      };
    };
  };
}
