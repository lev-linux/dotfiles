# User
set -Ux BAT_THEME gruvbox-dark
set -Ux BROWSER zen
set -Ux EDITOR nvim
set -Ux TERMINAL st

# WakaTime
set -Ux WAKATIME_HOME ~/.wakatime

# XDG
set -Ux XDG_RUNTIME_DIR /tmp/runtime-$USER

# NPM
set -Ux npm_config_cache ~/.cache/npm
set -Ux npm_config_prefix ~/.local/share/npm
set -Ux npm_config_userconfig ~/.config/npm/config

# GNU Readline
set -Ux INPUTRC "$HOME/.config/readline/inputrc"

# Void-specific
set -Ux XBPS_DISTDIR ~/.srcpkgs/void-packages/
set -Ux SVDIR ~/.config/service/
