#!/bin/sh 

cd ~/.srcpkgs
cd dwm && doas rm 'config.h' && doas make clean install && cd ..
cd dmenu && doas rm 'config.h' && doas make clean install && cd ..
cd sent && doas rm 'config.h' && doas make clean install && cd ..
cd slock && doas rm 'config.h' && doas make clean install && cd ..
cd st && doas make clean install && cd ..
