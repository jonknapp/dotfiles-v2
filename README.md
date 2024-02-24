# Dotfiles

This contains the Nix setup for my own robot army.

Each configuration is named with the pattern `user@hostname` since that's what
Home Manager will look for by default when ran with a flake. You can always
override that by specifying a custom config with the `--flake` option.

There are a few ways these dotfiles can be used depending on the situation.

1. You can reference this public repository to `build` or `switch` configurations.
2. You can clone this repository locally and reference it for `build` and `switch`.

If you clone the repository locally, you can optionally symlink it to
`~/config/home-manager` so that you don't need to specify the `flake.nix` location
for commands.

```sh
# For example, if this project was cloned to ~/dotfiles
ln -s ~/dotfiles ~/.config/home-manager
```

Following conventions, if we symlinked our cloned repo and set our computer's
hostname appropriately, running `home-manager switch` would be the same as specifying
`home-manager switch --flake ~/dotfiles#jon@megaman` on the `megaman` machine.

## Install Nix

Everything here requires Nix to be installed. As of the time this writing, you can
install Nix a few different ways:

1. (recommended) [Determinite Systems's installer](https://github.com/DeterminateSystems/nix-installer)
2. Following instructions on [Nix's website](https://nixos.org)

Once installed, you can verify it's setup by running `nix --version`.

If you use the default Nix install, you may need to add additional environment
variables (like the following) and pass `--impure` when running some of the commands.

`export NIX_CONFIG="experimental-features = nix-command flakes"`

## Activate a Configuration

### Without Home Manager Installed

The first time you want to configure Home Manager, it probably won't be
installed yet. You can use the following to run the latest version of
Home Manager from its Nix flake:

```sh
# If you want to run the flake from the internet
nix run home-manager/master -- switch --flake github:jonknapp/dotfiles-v2#jon@megaman

# or if you want to run it against a local copy
cd dotfiles # wherever the flake.nix file is located

# username and hostname match a configuration
nix run home-manager/master -- switch --flake .

# when you want to specify a configuration
nix run home-manager/master -- switch --flake .#jon@megaman
```

### With Home Manager Installed

Once Home Manager is configured, you won't need to reference the
online flake version and can instead run:

```sh
# If you want to run the flake from the internet
home-manager switch --flake github:jonknapp/dotfiles-v2#jon@megaman

# or if you want to run it against a local copy
cd dotfiles # wherever the flake.nix file is located

# username and hostname match a configuration
home-manager switch --flake .

# when you want to specify a configuration
home-manager switch --flake .#jon@megaman
```

## Build a Configuration

You can also build a Home Manager configuration without immediately switching
to it.

```sh
# If you want to run the flake from the internet
nix build github:jonknapp/dotfiles-v2#jon@megaman

# or if you want to run it against a local copy
cd dotfiles # wherever the flake.nix file is located
nix build .#jon@megaman
```

This requires manual activation by running `./result/activate` once built.

## Troubleshooting

To compare with what the latest recommended install would look like
for Home Manager + flakes, you can run:

```sh
export NIX_CONFIG="experimental-features = nix-command flakes"
nix run home-manager/master -- init ~/example/path
```

This will make a fresh `home.nix` and `flake.nix` file in the folder
`~/example/path/`.
