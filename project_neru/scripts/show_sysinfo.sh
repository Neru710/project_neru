#!/bin/bash

# ╭────────────────────────────────────────────╮
# │     📊 show_sysinfo.sh - project_neru      │
# │     Exibe info de sistema com presença     │
# ╰────────────────────────────────────────────╯

# Cores
CYAN="\e[36m"
MAGENTA="\e[35m"
YELLOW="\e[33m"
GREEN="\e[32m"
RESET="\e[0m"

# Arte ASCII (pequena mas impactante)
echo -e "${MAGENTA}"
echo "╭──────────[ 💻 SYSTEM INFO - NERU ]──────────╮"
echo -e "${RESET}"

# Modelo e marca da máquina
if [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
  MODEL=$(cat /sys/devices/virtual/dmi/id/product_name)
  MANUF=$(cat /sys/devices/virtual/dmi/id/sys_vendor)
else
  MODEL="N/A"
  MANUF="N/A"
fi

# CPU
CPU=$(lscpu | grep 'Model name' | cut -d ':' -f2 | sed 's/^[ \t]*//')

# GPU
GPU=$(lspci | grep -E "VGA|3D" | cut -d ':' -f3 | sed 's/^[ \t]*//')

# Memória RAM total
RAM=$(free -h | awk '/^Mem:/ { print $2 }')

# Kernel
KERNEL=$(uname -r)

# Distro
DISTRO=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '=' -f2 | tr -d '"')

# Exibe tudo com estilo
echo -e "${CYAN} 🏷️  Fabricante:   ${RESET}${MANUF}"
echo -e "${CYAN} 📦 Modelo:       ${RESET}${MODEL}"
echo -e "${CYAN} 🧠 CPU:          ${RESET}${CPU}"
echo -e "${CYAN} 🎮 GPU:          ${RESET}${GPU}"
echo -e "${CYAN} 🧪 RAM Total:    ${RESET}${RAM}"
echo -e "${CYAN} 🧵 Kernel:       ${RESET}${KERNEL}"
echo -e "${CYAN} 🐧 Distro:       ${RESET}${DISTRO}"

echo -e "${MAGENTA}╰────────────────────────────────────────────╯${RESET}"
