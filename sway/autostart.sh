#!/usr/bin/env bash
# autostart.sh - Ritual de ativação do ambiente sway project_neru
# ────────────────────────────────────────────────

# Função para rodar apps se não estiverem rodando
# Usa pgrep -f pra garantir que nomes longos sejam detectados
start_if_not_running() {
    pgrep -f "$1" > /dev/null || "$@" &
}

# ── Cursor padrão: variável de ambiente, não tem comando "xcursor-theme"
export XCURSOR_THEME="Bibata-Modern-Ice"
export XCURSOR_SIZE=24

# Esconde o cursor após 5s de inatividade no seat0
swaymsg seat seat0 hide_cursor 5000

# ── Papel de parede com hyprpaper (funciona no sway também)
start_if_not_running hyprpaper

# ── Bloqueador de tela e suspensão automática
start_if_not_running swayidle -w timeout 300 'swaylock -f' timeout 600 'systemctl suspend'

# ── Notificações via mako
start_if_not_running mako

# ── Polkit agente gráfico — usa caminho fixo, pois tá garantido
POLKIT_AGENT="/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
if [[ -x "$POLKIT_AGENT" ]]; then
    start_if_not_running "$POLKIT_AGENT"
else
    echo "⚠️ polkit-gnome authentication agent não encontrado. Instale o pacote polkit-gnome."
fi

# ── Waybar (barra de status) com log no cache
mkdir -p ~/.cache/waybar
start_if_not_running "waybar"

# ── Portal para apps sandboxed (Flatpak, etc)
start_if_not_running /usr/lib/xdg-desktop-portal

# ── Compositor extra (blur com wego) — ativar se quiser
# start_if_not_running wego

# ── NetworkManager applet
start_if_not_running nm-applet

# ── Pipewire e WirePlumber (som moderno)
start_if_not_running pipewire
start_if_not_running wireplumber

# ── Controle gráfico de som (pavucontrol) — descomente se quiser abrir no autostart
# start_if_not_running pavucontrol

# ── Terminal flutuante (opcional)
# start_if_not_running kitty --class floater

# ── Outras apps, coloca aqui o que quiser iniciar automaticamente
# start_if_not_running discord
# start_if_not_running firefox
