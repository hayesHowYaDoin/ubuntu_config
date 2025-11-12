{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.ghostty;
  wrappedGhostty = config.lib.nixGL.wrap pkgs.ghostty;
in {
  options.features.desktop.ghostty = {
    enable = mkEnableOption "Enable ghostty configuration.";
    nixGL = mkEnableOption "Whether or not to wrap ghostty with nixGL.";
    opacity = mkOption {
      type = types.float;
      example = 1.0;
      description = "Set window opacity.";
    };
    shader = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = ../assets/shaders/starfield-colors.glsl;
      description = "Set custom shader from glsl file.";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package =
        if cfg.nixGL
        then wrappedGhostty
        else pkgs.ghostty;
      settings =
        {
          background-opacity = cfg.opacity;
        }
        // lib.optionalAttrs (cfg.shader != builtins.null) {
          custom-shader = builtins.toString cfg.shader;
          custom-shader-animation = "always";
        };
    };

    xdg.desktopEntries.ghostty = {
      name = "Ghostty";
      genericName = "Terminal";
      exec = "${
        if cfg.nixGL
        then wrappedGhostty
        else pkgs.ghostty
      }/bin/ghostty";
      terminal = false;
      categories = ["System" "TerminalEmulator"];
      icon = "com.mitchellh.ghostty";
    };
  };
}
