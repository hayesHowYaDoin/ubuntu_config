{inputs, ...}: {
  imports = [
    ./cli
  ];

  targets.genericLinux.enable = true;

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

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
  };

  home = {
    username = "default";
    homeDirectory = /home/default;
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  programs.home-manager.enable = true;
}
