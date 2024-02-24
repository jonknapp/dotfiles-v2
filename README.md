# Dotfiles

## Activate a Configuration

To simplify selecting the correct Home Manager configuration, name them
like `user@hostname` to automatically pick the correct config. Otherwise, you
can specify the full path to the config when passing the `--flake` option.

### Without Home Manager Installed

The first time you want to configure Home Manager, it probably won't be
installed yet. You can use the following to run the latest version of
Home Manager from it's nix flake:

```sh
export NIX_CONFIG="experimental-features = nix-command flakes"
cd dotfiles # wherever the flake.nix file is located
nix run home-manager/master -- switch --flake .
nix run home-manager/master -- switch --flake .#jon@megaman
```

### With Home Manager Installed

Once Home Manager is configured, you won't need to reference the
online flake version and can instead run:

```sh
cd dotfiles # wherever the flake.nix file is located
home-manager switch --flake .
home-manager switch --flake .#jon@megaman
```

## Build a Configuration

You can also build a Home Manager configuration without immediately switching
to it.

```sh
cd dotfiles # wherever the flake.nix file is located
nix build .#jon@megaman
```

This requires manual activation by running `./result/activate` once built.

### Troubleshooting

To compare with what the latest recommended install would look like
for Home Manager + flakes, you can run:

```sh
export NIX_CONFIG="experimental-features = nix-command flakes"
nix run home-manager/master -- init ~/example/path
```

This will make a fresh `home.nix` and `flake.nix` file in the folder
`~/example/path/`.
