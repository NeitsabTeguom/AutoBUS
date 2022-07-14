#/bin/bash

pacman -Syu --noconfirm
pacman -S --noconfirm git mingw-w64-x86_64-gcc mingw-w64-x86_64-pkg-config mingw-w64-x86_64-vala zip unzip

pacman -S --noconfirm build-essential

pacman -S --noconfirm mingw-w64-x86_64-libsoup mingw-w64-x86_64-libgee mingw-w64-x86_64-json-glib
