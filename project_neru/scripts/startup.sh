#!/bin/bash

# ╭────────────────────────────────────────────╮
# │     🚀 startup.sh - project_neru           │
# │    Inicialização cirúrgica e estilosa      │
# ╰────────────────────────────────────────────╯

function run {
  if ! pgrep -x "$1" > /dev/null ; then
    "$@" &
  fi
}

sleep 1

# ─── 🔊 Áudio ─────────────────────────────────
run pipewire
run pipewire-pulse
run wireplumber

# ─── 🌐 Rede ──────────────────────────────────
run nm-applet

# ─── 📋 Área de transferência ────────────────
run clipman

# ─── 🌀 Tray de áudio ─────────────────────────
run pavucontrol --tray

# ─── 🔔 Notificações com estilo ──────────────
run dunst

# ─── 📊 Barra de status braba ────────────────
run waybar

# ─── 🖼️ Wallpaper com crossfade insano ────────
run hyprpaper

# ─── 🌙 Tema GTK escuro ───────────────────────
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

exit 0
