{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.ghostty;
in {
  options.features.desktop.ghostty = {
    enable = mkEnableOption "Enable ghostty configuration.";
    nixGL = mkEnableOption "Whether or not to wrap ghostty with nixGL";
    opacity = mkOption {
      type = types.float;
      example = 1.0;
      description = "Set window opacity.";
    };
    shader = mkOption {
      type = types.path;
      example = ../assets/shaders/starfield-colors.glsl;
      description = "Set custom shader from glsl file.";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package =
        if cfg.nixGL
        then config.lib.nixGL.wrap pkgs.ghostty
        else pkgs.ghostty;
      settings = {
        background-opacity = cfg.opacity;
        custom-shader = builtins.toString cfg.shader;
        custom-shader-animation = "always";
      };
    };
  };
}
