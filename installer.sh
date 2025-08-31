#!/bin/bash

# installer.sh - Script de Instalação/Atualização para Arch Linux (Sway, Waybar, Dotfiles, Fontes, Yay, Xwayland, XDG Portal e Diretórios de Usuário)

# --- Variáveis de Configuração ---
PROJECT_NAME="Configurações Sway/Waybar"
DOTFILES_REPO="https://github.com/Neru710/project_neru.git"
INSTALL_DIR="$HOME/.$PROJECT_NAME_temp" # Diretório temporário para clonar o dotfile e o yay
DOTFILES_LOCAL_PATH="$INSTALL_DIR/dotfiles" # Caminho onde os dotfiles serão clonados temporariamente
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
    echo "A instalação/atualização falhou. Verifique o log em: $LOG_FILE"
    echo "----------------------------------------------------"
    exit 1
}

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para copiar e atualizar os dotfiles (diretórios)
copy_dotfiles() {
    local source_dir="$1"
    local dest_dir="$2"
    local item_name="$3"

    log_message "Copiando/Atualizando $item_name para $dest_dir..."
    if [ -d "$source_dir" ]; then
        # Remove o diretório de destino se ele já existir para garantir uma cópia limpa e completa
        if [ -d "$dest_dir" ]; then
            log_message "Removendo $dest_dir existente antes de copiar..."
            rm -rf "$dest_dir" || error_exit "Falha ao remover $dest_dir."
        fi
        cp -r "$source_dir" "$dest_dir" || error_exit "Falha ao copiar a pasta '$item_name'."
        log_message "Pasta '$item_name' copiada/atualizada para $HOME/.config/."
    else
        log_message "Aviso: Pasta '$item_name' não encontrada no repositório clonado ($source_dir). Pulando cópia."
    fi
}

# --- Início do Script de Instalação/Atualização ---
log_message "Iniciando instalação/atualização de $PROJECT_NAME..."
echo "Log da instalação/atualização será salvo em: $LOG_FILE"

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
    sway
    swaybg
    firefox
    grim
    swappy
    slurp
    flatpak
    waybar
    pavucontrol
    cava
    mako
    sddm
    thunar
    engrampa
    unzip
    tar
    unrar
    wofi
    rofi
    kitty
    btop
    zsh # Garante que o zsh esteja instalado
    lxappearance
    qt5ct
    qt6ct
    kvantum-qt5
    git # Garante que o git esteja instalado para clonar o repositório e o yay
    # Início das fontes adicionadas
    ttf-dejavu
    ttf-liberation
    ttf-roboto
    ttf-ubuntu-font-family
    ttf-fira-code
    ttf-jetbrains-mono
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji # Já existia, mas mantido na lista para clareza
    ttf-droid
    ttf-inconsolata
    ttf-cascadia-code
    ttf-hack
    ttf-hack-nerd
    ttf-fira-sans
    ttf-nerd-fonts-symbols
    ttf-font-awesome
    # Fim das fontes adicionadas
    base-devel # Essencial para compilar pacotes do AUR (como o yay)
    xorg-xwayland # Adicionado para compatibilidade com aplicativos X11
    xdg-user-dirs # Para criar os diretórios padrão do usuário
    xdg-desktop-portal # XDG Desktop Portal principal
    xdg-desktop-portal-wlr # Backend para Sway/Wayland
    mpv # Adicionado MPV Player
    curl # Necessário para baixar o script de instalação do Oh My Zsh
)

log_message "Instalando pacotes necessários: ${PACKAGES[*]}..."
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}" || error_exit "Falha ao instalar um ou mais pacotes."
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

# 4-2. Instalar os temas para gtk e o qt5 e 6 (pacotes AUR)
install_aur_package() {
    local PACKAGE_NAME="$1"
    log_message "Instalando/Atualizando o pacote AUR ($PACKAGE_NAME) usando yay..."
    yay -S --noconfirm --needed "$PACKAGE_NAME" || error_exit "Falha ao instalar/atualizar o pacote AUR ($PACKAGE_NAME)."
    log_message "Pacote AUR ($PACKAGE_NAME) instalado/atualizado com sucesso."
}

AUR_PACKAGES=(
    "catppuccin-gtk-theme"
    "dracula-gtk-theme"
    "nordic-theme"
    "materia-gtk-theme"
    "arc-gtk-theme"
    "papirus-icon-theme"
    "ttf-firacode-nerd" # Fira Code Nerd Font
    "wlogout" # Adicionado wlogout
)

for pkg in "${AUR_PACKAGES[@]}"; do
    install_aur_package "$pkg"
done

# 5. Instalar Oh My Zsh e configurar shell padrão
log_message "Verificando e instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # O --unattended evita prompts interativos e define o zsh como shell padrão
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || error_exit "Falha ao instalar o Oh My Zsh."
    log_message "Oh My Zsh instalado com sucesso."
else
    log_message "Oh My Zsh já está instalado. Pulando instalação."
fi

# Mudar o shell padrão para Zsh (se ainda não for)
log_message "Definindo Zsh como shell padrão do usuário..."
ZSH_PATH=$(which zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    chsh -s "$ZSH_PATH" || error_exit "Falha ao mudar o shell padrão para Zsh."
    log_message "Shell padrão alterado para Zsh: $ZSH_PATH."
else
    log_message "Zsh já é o shell padrão. Pulando alteração."
fi


# 6. Clonar ou Atualizar o repositório de dotfiles
log_message "Verificando/Atualizando o repositório de dotfiles: $DOTFILES_REPO..."

# Cria o diretório temporário se não existir
mkdir -p "$INSTALL_DIR" || error_exit "Não foi possível criar o diretório temporário: $INSTALL_DIR."

if [ -d "$DOTFILES_LOCAL_PATH" ]; then
    log_message "Repositório de dotfiles já existe localmente. Puxando as últimas alterações..."
    (cd "$DOTFILES_LOCAL_PATH" && git pull) || error_exit "Falha ao puxar as últimas alterações do repositório de dotfiles."
    log_message "Repositório de dotfiles atualizado com sucesso."
else
    log_message "Clonando o repositório de dotfiles: $DOTFILES_REPO para $DOTFILES_LOCAL_PATH"
    git clone "$DOTFILES_REPO" "$DOTFILES_LOCAL_PATH" || error_exit "Falha ao clonar o repositório de dotfiles."
    log_message "Repositório de dotfiles clonado com sucesso."
fi

# 7. Criar diretórios padrão do usuário
log_message "Verificando e criando diretórios padrão do usuário (Downloads, Documentos, etc.)..."
xdg-user-dirs-update || log_message "Aviso: Falha ao criar/atualizar diretórios do usuário com xdg-user-dirs-update."
log_message "Diretórios padrão do usuário verificados/criados."

# 8. Copiar/Atualizar configurações de Sway, Waybar, wlogout e .zshrc
log_message "Copiando/Atualizando configurações de sway, waybar, wlogout e .zshrc para ~/.config/ e $HOME/..."

# Cria o diretório .config se não existir
mkdir -p "$HOME/.config/" || error_exit "Não foi possível criar o diretório $HOME/.config/."

# Usando a função copy_dotfiles para simplificar e garantir atualização (para diretórios)
copy_dotfiles "$DOTFILES_LOCAL_PATH/sway" "$HOME/.config/sway" "sway"
copy_dotfiles "$DOTFILES_LOCAL_PATH/waybar" "$HOME/.config/waybar" "waybar"
copy_dotfiles "$DOTFILES_LOCAL_PATH/wlogout" "$HOME/.config/wlogout" "wlogout"
copy_dotfiles "$DOTFILES_LOCAL_PATH/rofi" "$HOME/.config/rofi" "rofi"
copy_dotfiles "$DOTFILES_LOCAL_PATH/nvim" "$HOME/.config/nvim" "nvim"

# Copiar .zshrc do repositório de dotfiles para $HOME/
log_message "Copiando/Atualizando .zshrc do repositório de dotfiles para $HOME/..."
if [ -f "$DOTFILES_LOCAL_PATH/.zshrc" ]; then
    cp -f "$DOTFILES_LOCAL_PATH/.zshrc" "$HOME/.zshrc" || error_exit "Falha ao copiar o arquivo .zshrc."
    log_message ".zshrc copiado/atualizado para $HOME/."
else
    log_message "Aviso: Arquivo .zshrc não encontrado no repositório clonado ($DOTFILES_LOCAL_PATH/.zshrc). Pulando cópia."
fi

# Instalar plugins Zsh (clonar repositórios)
log_message "Clonando plugins Zsh (zsh-autosuggestions, zsh-syntax-highlighting)..."
ZSH_CUSTOM_PLUGINS="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
mkdir -p "$ZSH_CUSTOM_PLUGINS" # Garante que o diretório exista

if [ ! -d "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions" || log_message "Aviso: Falha ao clonar zsh-autosuggestions."
else
    log_message "zsh-autosuggestions já clonado. Pulando."
fi

if [ ! -d "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" || log_message "Aviso: Falha ao clonar zsh-syntax-highlighting."
else
    log_message "zsh-syntax-highlighting já clonado. Pulando."
fi
log_message "Clonagem de plugins Zsh concluída."

# Configurar plugins Zsh no ~/.zshrc (garante que os plugins estejam listados)
log_message "Configurando plugins Zsh no ~/.zshrc..."
if [ -f "$HOME/.zshrc" ]; then
    # Garante que a linha 'plugins=(...)' exista e contenha os plugins desejados.
    # Primeiro, remove qualquer linha 'plugins=(...)' existente.
    sed -i '/^plugins=(/d' "$HOME/.zshrc"
    # Em seguida, adiciona a linha com os plugins desejados no final do arquivo.
    echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> "$HOME/.zshrc" || log_message "Aviso: Falha ao adicionar/atualizar a linha de plugins Zsh no ~/.zshrc. Verifique manualmente."
    log_message "Plugins Zsh configurados com sucesso no ~/.zshrc."
else
    log_message "Aviso: ~/.zshrc não encontrado após cópia. Pule a configuração de plugins Zsh."
fi

# Garante permissão de execução para scripts específicos após a cópia
SCRIPTS_TO_CHMOD=(
    "$HOME/.config/waybar/scripts/power-menu.sh"
    "$HOME/.config/sway/scripts/screenshot.sh"
    # Adicione outros scripts que precisam de permissão de execução aqui
)

for script in "${SCRIPTS_TO_CHMOD[@]}"; do
    if [ -f "$script" ]; then
        log_message "Dando permissão de execução para o script $script..."
        chmod +x "$script" || error_exit "Falha ao dar permissão de execução para $script."
        log_message "Permissão de execução concedida para $script."
    else
        log_message "Aviso: Script $script não encontrado após a cópia. Certifique-se de que ele está no seu repositório dotfiles."
    fi
done

# 9. Habilitar o SDDM (apenas se ainda não estiver habilitado)
log_message "Verificando e habilitando o serviço SDDM para iniciar com o sistema..."
if ! systemctl is-enabled sddm &> /dev/null; then
    sudo systemctl enable sddm || error_exit "Falha ao habilitar o serviço SDDM."
    log_message "SDDM habilitado com sucesso."
else
    log_message "SDDM já está habilitado. Pulando habilitação."
fi

# 10. Configurar WAYLAND_DISPLAY e XDG_CURRENT_DESKTOP em ~/.config/environment.d/
log_message "Configurando variáveis de ambiente em ~/.config/environment.d/..."
ENV_D_DIR="$HOME/.config/environment.d"
mkdir -p "$ENV_D_DIR" || error_exit "Falha ao criar o diretório $ENV_D_DIR."

# Configura WAYLAND_DISPLAY
WAYLAND_ENV_FILE="$ENV_D_DIR/wayland.conf"
WAYLAND_DISPLAY_VALUE="${WAYLAND_DISPLAY:-wayland-0}" # Usa o valor atual ou 'wayland-0' como fallback

# Remove qualquer linha WAYLAND_DISPLAY= existente para evitar duplicatas ou conflitos
sed -i '/^WAYLAND_DISPLAY=/d' "$WAYLAND_ENV_FILE" 2>/dev/null
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY_VALUE}" >> "$WAYLAND_ENV_FILE" || error_exit "Falha ao adicionar WAYLAND_DISPLAY a $WAYLAND_ENV_FILE."
log_message "WAYLAND_DISPLAY=${WAYLAND_DISPLAY_VALUE} adicionado a $WAYLAND_ENV_FILE com sucesso."

# Configura XDG_CURRENT_DESKTOP
DESKTOP_ENV_FILE="$ENV_D_DIR/desktop.conf"
# Remove qualquer linha XDG_CURRENT_DESKTOP= existente
sed -i '/^XDG_CURRENT_DESKTOP=/d' "$DESKTOP_ENV_FILE" 2>/dev/null
echo "XDG_CURRENT_DESKTOP=sway" >> "$DESKTOP_ENV_FILE" || error_exit "Falha ao adicionar XDG_CURRENT_DESKTOP."
log_message "XDG_CURRENT_DESKTOP=sway adicionado a $DESKTOP_ENV_FILE com sucesso."


# 11. Configurar QT_QPA_PLATFORMTHEME em /etc/environment
log_message "Configurando QT_QPA_PLATFORMTHEME para qt5ct em /etc/environment..."
ENV_VAR_LINE="QT_QPA_PLATFORMTHEME=qt5ct"
GLOBAL_ENV_FILE="/etc/environment"

# Verifica se existe alguma linha começando com QT_QPA_PLATFORMTHEME e a remove para evitar duplicatas ou conflitos
sudo sed -i '/^QT_QPA_PLATFORMTHEME=/d' "$GLOBAL_ENV_FILE" 2>/dev/null
# Adiciona a nova linha ao final do arquivo
echo "$ENV_VAR_LINE" | sudo tee -a "$GLOBAL_ENV_FILE" > /dev/null || error_exit "Falha ao adicionar '$ENV_VAR_LINE' a $GLOBAL_ENV_FILE."
log_message "'$ENV_VAR_LINE' adicionado a $GLOBAL_ENV_FILE com sucesso."

# 12. Limpar o diretório temporário
log_message "Removendo diretório temporário: $INSTALL_DIR"
rm -rf "$INSTALL_DIR" || log_message "Aviso: Não foi possível remover o diretório temporário $INSTALL_DIR."

# --- Finalização ---
log_message "Instalação/Configuração/Atualização de $PROJECT_NAME concluídas com sucesso!"
echo ""
echo "----------------------------------------------------"
echo "Instalação/Atualização Concluída!"
echo "Os diretórios padrão do usuário foram criados/verificados."
echo "O XDG Desktop Portal para Wayland foi instalado."
echo "Os dotfiles foram clonados/atualizados."
echo "O Zsh e Oh My Zsh foram instalados e configurados."
echo "Você precisa REINICIAR o sistema agora para que as alterações entrem em vigor,"
echo "e o SDDM inicie permitindo que você selecione a sessão Sway."
echo "O log completo da instalação/atualização está em: $LOG_FILE"
echo "----------------------------------------------------"
echo ""

# Recomendação de Reinício Mais Forte
echo "Deseja reiniciar o sistema agora? (s/N): "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    log_message "Reiniciando o sistema..."
    sudo reboot
else
    log_message "Reinício adiado pelo usuário."
fi

exit 0
