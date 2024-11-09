{ pkgs, ... }: {
  # Used for backwards compatibility. please read the changelog
  # before changing: `darwin-rebuild changelog`.      
  system.stateVersion = 4;

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.firekind = {
    name = "firekind";
    home = "/Users/firekind";
  };
  programs.zsh.enable = true;
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };
  security.pam.enableSudoTouchIdAuth = true;
}