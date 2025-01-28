{ config, pkgs, user, ... }: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [
      "Cascadia Code"
      "JetBrains Mono"
    ];
  };

  home = {
    file = {
      "Pictures/Wallpapers".source = ../../../data/wallpapers;
      ".vimrc".source = ../../../data/vim/config;
      ".config/ghostty/config".text = ''
          window-padding-x = 5
          window-padding-y = 5
          theme = "PencilDark"
          cursor-style = "block"
          shell-integration-features = "no-cursor"
        '';
    };
    homeDirectory = user.home-dir;
    packages = with pkgs; [
      awscli2
      bat
      cascadia-code
      eza
      gh
      google-cloud-sdk
      jetbrains-mono
      oh-my-zsh
      uv
    ];
  
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05";

    username = user.name;  
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    home-manager.enable = true;
    zsh = {
      autosuggestion.enable = true;
      enable = true;
      initExtra = "${builtins.readFile ../../../data/zsh/linux-config.zsh}";
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
        ls = "eza -al";
        less = "bat";
        cdmr = "cd ~/Documents/Projects/mr";
        cdp = "cd ~/Documents/Projects";
      };
      syntaxHighlighting.enable = true;
    };
  };
}
