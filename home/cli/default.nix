{pkgs, ...}: {
  imports = [./git.nix ./neofetch.nix ./zsh.nix];

  home.packages = with pkgs; [
    bat
    caligula
    chafa
    claude-code
    coreutils
    devenv
    direnv
    dust
    eza
    fd
    fzf
    htop
    lazygit
    nitch
    nvim
    nvtopPackages.full
    oh-my-posh
    presenterm
    ripgrep
    tldr
    tmux
    typst
    usbutils
    yazi
    zip
    zoxide
  ];
}
