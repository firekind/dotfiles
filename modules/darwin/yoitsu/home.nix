{pkgs, ...}: {
  home = {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05";

    packages = with pkgs; [
      alejandra
      bat
      binutils
      cascadia-code
      eza
      htop
      jetbrains-mono
      nil
      oh-my-zsh
      vim
    ];
    file = {
      ".vimrc".source = ../../../data/vim/config;
      "Pictures/dotfiles-wallpapers".source = ../../../data/wallpapers;
    };
  };

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      sessionVariables = {
        ZSH_COMPDUMP = "$HOME/.cache/.zcompdump-$HOST";
        MANROFFOPT = "-c";
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
      shellAliases = {
        ls = "eza -al";
        less = "bat";
        cdp = "cd ~/Projects";
        cdmr = "cd ~/Projects/MR";
        cdfe = "cd ~/Projects/federate";
        cdw = "cd ~/Projects/workbench";
      };
      initContent = "${builtins.readFile ../../../data/zsh/darwin-config.zsh}";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = "gallifrey";
      };
    };
  };

  fonts.fontconfig = {
    enable = true;
  };
}
