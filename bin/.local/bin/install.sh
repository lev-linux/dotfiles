#!/bin/sh 

# install
## update
sudo xbps-install -Syu;sudo xbps-install -Syu 

## install voidrice
### install git
sudo xbps-install -y git 
### clone voidrice
git clone https://github.com/LEV-Linux/voidrice.git

cp ./voidrice/* ~/

## instal doas
# sudo xbps-install -y opendoas
# ### config
# sudo cp voidrice/.config/doas.conf /etc/doas.conf 

readonly X_PKGS="sx xorg-minimal xorg-input-drivers xorg-video-drivers setxkbmap xauth font-misc-misc terminus-font dejavu-fonts-ttf alsa-plugins-pulseaudio"
readonly MINIMAL_PKGS="$X_PKGS zsh zsh-autosuggestions zsh-syntax-highlighting neovim htop opendoas nnn fzf wget make cmake gcc brillo kmonad xtools python"
readonly FUNCTIONAL_PKGS="$MINIMAL_PKGS dwm st dmenu qutebrowser zathura zathura-pdf-mupdf sxhkd sxiv mpv hyperfine"
readonly FULL_PKGS="$FUNCTIONAL_PKGS ImageMagick ffmpeg bottom task timewarrior picom pywal xwinwrap libX11-devel libXinerama-devel libXft-devel fontconfig-devel font-awesome font-symbola  ncurses-devel st-terminfo freetype-devel pkg-config harfbuzz-devel xdotool xdo zathura-ps github-cli grip ripgrep go neomutt pass pass-otp passmenu neofetch syncthing"

doas xbps-install -y "$FULL_PKGS"

# window manager (dwm)
git clone https://github.com/LEV-Linux/lev-dwm.git ~/.srcpkgs/lev-dwm/
# application luncher (dmenu)
git clone https://github.com/LEV-Linux/lev-dmenu.git ~/.srcpkgs/lev-dmenu/
# status bar (dwmblocks)
git clone https://github.com/LEV-Linux/lev-dwmblocks.git ~/.srcpkgs/lev-dwmblocks/
# terminal (st)
git clone https://github.com/salahdin-ahmed/st.git ~/.srcpkgs/st/

chsh -s /bin/zsh 

cd ~/.srcpkgs/lev-dwm/ 
make clean install

cd ~/.srcpkgs/lev-dwmblocks/ 
make clean install

cd ~/.srcpkgs/lev-dmenu/ 
make clean install

cd ~/.srcpkgs/st/ 
make clean install
