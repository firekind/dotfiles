{lib, ...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = [
      "cocoapods"
      "dive"
      "tree"
      "uv"
    ];
    casks = [
      "keymapp"
      "postman"
    ];
  };
  networking = {
    hostName = "yoitsu";
  };
  nix = {
    enable = true;
    settings.experimental-features = "nix-command flakes";
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    # Used for backwards compatibility. please read the changelog
    # before changing: `darwin-rebuild changelog`.
    stateVersion = 6;

    primaryUser = "firekind";

    activationScripts = {
      disableHotKeys = {
        enable = true;
        text = let
          hotkeysToDisable = [
            64 # Spotlight -> Show Spotlight search
            65 # Spotlight -> Show finder search window
          ];
          disableHotkeysCmd =
            map (
              key: "plutil -replace AppleSymbolicHotKeys.${toString key}.enabled -bool NO ~/Library/Preferences/com.apple.symbolichotkeys.plist"
            )
            hotkeysToDisable;
        in ''
          ${lib.concatStringsSep "\n" disableHotkeysCmd}
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';
      };
    };

    defaults = {
      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = true;
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
      };

      dock = {
        autohide = true;
        mru-spaces = false;
        persistent-apps = [
          "/System/Applications/Launchpad.app"
        ];
        show-recents = false;
        tilesize = 48;
      };

      finder = {
        CreateDesktop = false; # whether to show icons on desktop or not
        FXPreferredViewStyle = "icnv";
        NewWindowTarget = "Home";
        ShowPathbar = false;
      };

      hitoolbox = {
        AppleFnUsageType = "Do Nothing";
      };

      trackpad = {
        Clicking = true; # tap to click
      };

      NSGlobalDomain = {
        NSDocumentSaveNewDocumentsToCloud = false;
        "com.apple.swipescrolldirection" = true; # natural scrolling
      };

      WindowManager = {
        EnableStandardClickToShowDesktop = false;
      };
    };
  };

  users.users.firekind = {
    name = "firekind";
    home = "/Users/firekind";
  };
}
