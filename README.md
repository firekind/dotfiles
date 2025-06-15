# Dotfiles

contains dotfiles. 

## Linux
Set up via home manager:

```
nix run home-manager -- switch --flake ./modules/linux
```

## Darwin
Set up via nix-darwin:

For first run:

```
sudo nix run nix-darwin -- switch --flake ./modules/darwin
```

Subsequent runs can use:

```
sudo darwin-rebuild switch --flake ./modules/darwin
```

instead
