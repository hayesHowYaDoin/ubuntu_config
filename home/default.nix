{inputs, ...}: {
  imports = [
    ./cli
    ./desktop
  ];

  targets.genericLinux = {
    enable = true;
    nixGL = {
      packages = inputs.nixgl.packages;
      installScripts = ["mesa"];
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-medium;

  features = {
    cli = {
      git = {
        enable = true;
        userName = "hayesHowYaDoin";
        userEmail = "jordanhayes98@gmail.com";
      };
      neofetch.enable = true;
      nvim = {
        enable = true;
        theme = {
          name = "gruvbox-material";
          style = "dark-medium";
        };
      };
      zsh = {
        enable = true;
        theme = ../assets/mine.omp.json;
      };
    };
    desktop = {
      fonts.enable = true;
      ghostty = {
        enable = true;
        nixGL = true;
        opacity = 0.9;
        shader = ../assets/cursor_warp.glsl;
      };
      obsidian = {
        enable = true;
        nixGL = true;
      };
      gnome = {
        enable = true;
        background = ../assets/wallpaper.jpeg;
        backgroundDark = ../assets/wallpaper.jpeg;
      };
    };
  };

  home = {
    username = "default";
    homeDirectory = /home/default;
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  programs.home-manager.enable = true;
}
