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

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  features = {
    cli = {
      git = {
        enable = true;
        userName = "hayesHowYaDoin";
        userEmail = "jordanhayes98@gmail.com";
      };
      neofetch.enable = true;
      zsh = {
        enable = true;
        theme = ../assets/pure.omp.json;
      };
    };
    desktop = {
      fonts.enable = true;
      ghostty = {
        enable = true;
        nixGL = true;
        opacity = 0.8;
        # shader = ../assets/cursor.glsl;
      };
      dconf = {
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
