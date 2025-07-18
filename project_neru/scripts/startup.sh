#!/bin/bash

# ╭────────────────────────────────────────────╮
# │                FUNÇÃO RUN                   │
# │ Executa um programa se ele não estiver rodando │
# ╰────────────────────────────────────────────╯
function run {
  if ! pgrep -x "$1" > /dev/null ; then
    "$@" &
  fi
}

sleep 1  # Dá um tempo pra o sistema acordar

# ╭────────────────────────────────────────────╮
# │                  ÁUDIO                      │
# ╰────────────────────────────────────────────╯
run pipewire
run pipewire-pulse
run wireplumber

# ╭────────────────────────────────────────────╮
# │                   REDE                      │
# ╰────────────────────────────────────────────╯
run nm-applet

# ╭────────────────────────────────────────────╮
# │           ÁREA DE TRANSFERÊNCIA             │
# ╰────────────────────────────────────────────╯
run clipman

# ╭────────────────────────────────────────────╮
# │        CONTROLE DE ÁUDIO NA TRAY            │
# ╰────────────────────────────────────────────╯
run pavucontrol --tray

# ╭────────────────────────────────────────────╮
# │               NOTIFICAÇÕES                  │
# ╰────────────────────────────────────────────╯
run dunst

# ╭────────────────────────────────────────────╮
# │              BARRA DE STATUS                │
# ╰────────────────────────────────────────────╯
run waybar

# ╭────────────────────────────────────────────╮
# │              WALLPAPER HYPRPAPER            │
# ╰────────────────────────────────────────────╯
run hyprpaper --daemon
sleep 0.5
run hyprpaper --set-wallpaper ~/.config/wallpapers/zen.jpg

# ╭────────────────────────────────────────────╮
# │            TEMA ESCURO GTK                  │
# ╰────────────────────────────────────────────╯
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

exit 0
