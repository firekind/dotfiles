{ config, pkgs, ... }: {
  home = {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05";

    username = "firekind";
    homeDirectory = "/home/firekind";
    packages = with pkgs; [
      eza
      bat
      cascadia-code
      jetbrains-mono
      oh-my-zsh
      vim
      htop
    ];
    file = {
      "Pictures/Wallpapers".source = ../../data/wallpapers;
      ".vimrc".source = ../../data/vim/config;
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
        MANROFFOPT="-c";
        MANPAGER="sh -c 'col -bx | bat -l man -p'";
      };
      shellAliases = {
        cdp = "cd /media/d/Projects";
        cdmr = "cd /media/d/Projects/mr";
        cdw = "cd /media/d/Projects/workbench";
        ls = "eza -al";
        less = "bat";
        vsd = "vscode-distrobox";
        distrobox = "env -u ZDOTDIR -u PATH $__distrobox_bin";
      };
      initExtra = "${builtins.readFile ../../data/zsh/linux-config.zsh}";
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
    defaultFonts.monospace = [
      "Cascadia Code"
      "JetBrains Mono"
    ];
  };
}
