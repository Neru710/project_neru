#!/bin/bash

# ~/.config/waybar/scripts/power-menu.sh
# Script para menu de opções de energia usando wofi

# Opções do menu
options="Desligar\nReiniciar\nSuspender\nCancelar"

# Executa o wofi e pega a seleção do usuário
selected_option=$(echo -e "$options" | wofi --dmenu --prompt "Opções de Energia:")

# Ação baseada na seleção
case "$selected_option" in
    "Desligar")
        systemctl poweroff
        ;;
    "Reiniciar")
        systemctl reboot
        ;;
    "Suspender")
        systemctl suspend
        ;;
    "Cancelar")
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
