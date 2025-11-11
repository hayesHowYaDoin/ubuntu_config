{pkgs, ...}: {
  imports = [
    ./cli
    #    ./modules/desktop
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ../assets/wallpaper.jpeg;
  };

  targets.genericLinux.enable = true;

  features = {
    cli = {
      git = {
        enable = true;
        userName = "hayesHowYaDoin";
        userEmail = "jordanhayes98@gmail.com";
      };
      neofetch.enable = false;
      zsh = {
        enable = true;
        theme = ../assets/pure.omp.json;
      };
    };
    #    desktop = {
    #      fonts.enable = true;
    #      ghostty.enable = true;
    #      plasma.enable = true;
    #      vscode.enable = true;
    #      xdg.enable = true;
    #    };
  };

  home = {
    username = "default";
    homeDirectory = /home/default;
    stateVersion = "24.11"; # Please read the comment before changing.
    packages = with pkgs; [
      # TODO: Add packages
    ];
  };

  programs.home-manager.enable = true;
}
