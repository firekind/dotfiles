{ config, pkgs, ... }: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [
      "Cascadia Code"
      "JetBrains Mono"
    ];
  };

  home = {
    file = {
      "Pictures/Wallpapers".source = ../../data/wallpapers;
      ".vimrc".source = ../../data/vim/config;
    };
    homeDirectory = "/home/firekind";
    packages = with pkgs; [
      awscli2
      bat
      cascadia-code
      eza
      gh
      google-cloud-sdk
      htop
      jetbrains-mono
      oh-my-zsh
      vim
    ];
  
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05";

    username = "firekind";  
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        window-padding-x = 5;
        window-padding-y = 5;
        theme = "PencilDark";
        cursor-style = "block";
        shell-integration-features = "no-cursor";
      };
    };
    home-manager.enable = true;
    zsh = {
      autosuggestion.enable = true;
      enable = true;
      initExtra = "${builtins.readFile ../../data/zsh/linux-config.zsh}";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = "gallifrey";
      };
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
      syntaxHighlighting.enable = true;
    };
  };
}
