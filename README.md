# Dotfiles

contains dotfiles. 

## Linux
Set up via home manager:

```
nix run home-manager/release-24.11 -- switch --flake ./modules/linux
```

## Darwin
Set up via nix-darwin:

For first run:

```
nix run nix-darwin -- switch --flake ./modules/darwin
```

Subsequent runs can use:

```
darwin-rebuild switch --flake ./modules/darwin
```

instead
