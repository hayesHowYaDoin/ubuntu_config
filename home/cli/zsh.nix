{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh = {
    enable = mkEnableOption "Enable zsh configuration.";
    theme = mkOption {
      type = types.path;
      example = ../assets/pure.omp.json;
      description = "Path to the desired oh-my-posh theme.";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      initContent = ''
        # Keybinds
        bindkey -e
        bindkey '^ ' autosuggest-accept
        bindkey '^[OA' history-search-backward
        bindkey '^[OB' history-search-forward

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        # Shell integrations
        eval "$(fzf --zsh)"
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(direnv hook zsh)"
        eval "$(oh-my-posh init zsh --config ${cfg.theme})"
      '';

      history = {
        size = 5000;
        save = 5000;
        path = "$HOME/.zsh_history";
        append = true;
        share = true;
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
      };

      zplug = {
        enable = true;
        plugins = [
          {name = "wintermi/zsh-oh-my-posh";}
          {name = "zsh-users/zsh-syntax-highlighting";}
          {name = "zsh-users/zsh-completions";}
          {name = "zsh-users/zsh-autosuggestions";}
          {name = "Aloxaf/fzf-tab";}
        ];
      };

      shellAliases = {
        os = "sudo nixos-rebuild switch --flake";
        home = "home-manager switch --flake";
        ls = "eza";
        c = "clear";
        v = "nvim";
        cat = "bat";
        du = "dust";
        lgit = "lazygit";
      };
    };
  };
}
