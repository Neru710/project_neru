#!/bin/bash

# installer.sh - Script de Instalação para Arch Linux (Sway, Waybar, Dotfiles, Fontes e Yay)

# --- Variáveis de Configuração ---
PROJECT_NAME="Configurações Sway/Waybar"
DOTFILES_REPO="https://github.com/Wagner0070/project_neru.git"
INSTALL_DIR="$HOME/.$PROJECT_NAME_temp" # Diretório temporário para clonar o dotfile
LOG_FILE="/tmp/${PROJECT_NAME// /_}_install.log" # Arquivo de log temporário

# --- Funções Auxiliares ---

# Função para exibir mensagens de status
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Função para exibir erros e sair
error_exit() {
    log_message "ERRO: $1"
    echo "----------------------------------------------------"
    echo "A instalação falhou. Verifique o log em: $LOG_FILE"
    echo "----------------------------------------------------"
    exit 1
}

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Início do Script de Instalação ---
log_message "Iniciando instalação de $PROJECT_NAME..."
echo "Log da instalação será salvo em: $LOG_FILE"

# 1. Verificar se o pacman existe (garantir que é Arch)
log_message "Verificando se o gerenciador de pacotes pacman está disponível..."
if ! command_exists "pacman"; then
    error_exit "Este script é para Arch Linux e o pacman não foi encontrado."
fi

# 2. Atualizar o sistema
log_message "Atualizando o sistema Arch Linux..."
sudo pacman -Syu --noconfirm || error_exit "Falha ao atualizar o sistema."
log_message "Sistema atualizado com sucesso."

# 3. Instalar pacotes necessários (do repositório oficial)
PACKAGES=(
    wayland
    waybar
    mako
    sddm
    dolphin
    wofi
    kitty
    git # Garante que o git esteja instalado para clonar o repositório e o yay
    noto-fonts-emoji # Boa para complementar com símbolos e emojis em fontes
    base-devel # Essencial para compilar pacotes do AUR (como o yay)
)

log_message "Instalando pacotes necessários: ${PACKAGES[*]}..."
sudo pacman -S --noconfirm "${PACKAGES[@]}" || error_exit "Falha ao instalar um ou mais pacotes."
log_message "Pacotes instalados com sucesso."

# 4. Instalar Yay (se não estiver instalado)
log_message "Verificando e instalando o Yay (AUR helper)..."
if ! command_exists "yay"; then
    log_message "Yay não encontrado. Clonando e instalando yay..."
    git clone https://aur.archlinux.org/yay.git "$INSTALL_DIR/yay-build" || error_exit "Falha ao clonar o repositório do yay."
    (cd "$INSTALL_DIR/yay-build" && makepkg -si --noconfirm) || error_exit "Falha ao compilar e instalar o yay."
    log_message "Yay instalado com sucesso."
else
    log_message "Yay já está instalado. Pulando instalação."
fi

# 5. Instalar Nerd Font específica usando yay
# ttf-firacode-nerd é a Fira Code com os glyphs da Nerd Font, que é muito popular.
NERD_FONT_PACKAGE="ttf-firacode-nerd"
log_message "Instalando a Nerd Font ($NERD_FONT_PACKAGE) usando yay..."
yay -S --noconfirm "$NERD_FONT_PACKAGE" || error_exit "Falha ao instalar a Nerd Font ($NERD_FONT_PACKAGE)."
log_message "Nerd Font ($NERD_FONT_PACKAGE) instalada com sucesso."

# 6. Clonar o repositório de dotfiles
log_message "Clonando o repositório de dotfiles: $DOTFILES_REPO para $INSTALL_DIR"
git clone "$DOTFILES_REPO" "$INSTALL_DIR/dotfiles" || error_exit "Falha ao clonar o repositório de dotfiles."
log_message "Repositório de dotfiles clonado com sucesso."

# 7. Copiar as pastas 'sway' e 'waybar' para ~/.config/
log_message "Copiando configurações de sway e waybar para ~/.config/..."

# Cria o diretório .config se não existir
mkdir -p "$HOME/.config/" || error_exit "Não foi possível criar o diretório $HOME/.config/."

# Cópia da pasta 'sway'
if [ -d "$INSTALL_DIR/dotfiles/sway" ]; then
    cp -r "$INSTALL_DIR/dotfiles/sway" "$HOME/.config/" || error_exit "Falha ao copiar a pasta 'sway'."
    log_message "Pasta 'sway' copiada para ~/.config/."
else
    log_message "Aviso: Pasta 'sway' não encontrada no repositório clonado. Pulando cópia."
fi

# Cópia da pasta 'waybar'
if [ -d "$INSTALL_DIR/dotfiles/waybar" ]; then
    cp -r "$INSTALL_DIR/dotfiles/waybar" "$HOME/.config/" || error_exit "Falha ao copiar a pasta 'waybar'."
    log_message "Pasta 'waybar' copiada para ~/.config/."
else
    log_message "Aviso: Pasta 'waybar' não encontrada no repositório clonado. Pulando cópia."
fi

# 8. Habilitar o SDDM
log_message "Habilitando o serviço SDDM para iniciar com o sistema..."
sudo systemctl enable sddm || error_exit "Falha ao habilitar o serviço SDDM."
log_message "SDDM habilitado com sucesso."

# 9. Limpar o diretório temporário
log_message "Removendo diretório temporário: $INSTALL_DIR"
rm -rf "$INSTALL_DIR" || log_message "Aviso: Não foi possível remover o diretório temporário $INSTALL_DIR."

# --- Finalização ---
log_message "Instalação e configuração de $PROJECT_NAME concluídas com sucesso!"
echo ""
echo "----------------------------------------------------"
echo "Instalação Concluída!"
echo "O SDDM foi habilitado e a sua Nerd Font favorita instalada."
echo "Você precisa REINICIAR o sistema agora para que o SDDM inicie e você possa selecionar a sessão Sway."
echo "O log completo da instalação está em: $LOG_FILE"
echo "----------------------------------------------------"
echo ""
