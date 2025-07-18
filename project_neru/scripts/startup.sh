#!/bin/bash

function run {
  if ! pgrep -x "$1" > /dev/null ; then
    "$@" &
  fi
}

sleep 1

# Áudio
run pipewire
run pipewire-pulse
run wireplumber

# Rede
run nm-applet

# Área de transferência
run clipman

# Controle de áudio no tray
run pavucontrol --tray

# Notificações
run mako

# Barra de status
run waybar

# Wallpaper
run swww init
run swww img ~/.config/wallpapers/zen.jpg

# Tema escuro GTK
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

exit 0

