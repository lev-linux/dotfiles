#!/bin/sh
wal --theme base16-gruvbox-medium -l
pkill -SIGUSR1 st
pkill dunst
