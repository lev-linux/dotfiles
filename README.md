# Dotfiles

This repository contains my configuration files (dotfiles) for various programs, managed using [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

### Prerequisites
Make sure you have GNU Stow installed. On Void Linux, you can install it with:

```sh
sudo xbps-install -S stow
```

### Cloning the Repository
Clone this repository into your home directory (or any location you prefer):

```sh
git clone https://github.com/lev-linux/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Stowing Configurations
To create symlinks for a specific program, use:

```sh
stow <package>
```

For example, to apply the configurations for `dwm` and `zsh`, run:

```sh
stow dwm
stow zsh
```

This will create symlinks in your home directory (`~`), pointing to the corresponding files in `~/.dotfiles/dwm/` and `~/.dotfiles/zsh/`.

If you need to overwrite existing files, use:

```sh
stow -D <package>
```

before restowing to remove old symlinks.

### Directory Structure
Each configuration is stored in a separate directory, mimicking the home directory structure. For example:

```
~/.dotfiles/
├── dwm/
│   ├── .config/dwm/config.h
│   ├── .config/dwm/autostart.sh
│   └── ...
├── zsh/
│   ├── .zshrc
│   ├── .zshenv
│   └── ...
└── ...
```

### Updating Configurations
To update a configuration, modify the files inside `~/.dotfiles/<package>/`, then commit and push the changes.

### Unstowing Configurations
To remove symlinks for a specific package, use:

```sh
stow -D <package>
```

## Customization
Feel free to modify these dotfiles to suit your workflow. If you use different paths or need additional setups, update this README accordingly!
