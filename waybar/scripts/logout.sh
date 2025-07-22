#!/bin/bash

# Script para exibir o menu de logout/desligamento wlogout

# Caminho para o executável do wlogout (geralmente /usr/bin/wlogout)
WLOGOUT_CMD="/usr/bin/wlogout"

# Verifica se o wlogout está instalado
if ! command -v "$WLOGOUT_CMD" &> /dev/null; then
    echo "Erro: wlogout não encontrado. Certifique-se de que está instalado."
    exit 1
fi

# Abre o wlogout.
# As opções -b (background) e -L (lock screen) são exemplos.
# Consulte `man wlogout` para todas as opções.
# É comum usar -p (position) para centralizar ou posicionar o menu.
# Exemplo: wlogout -p 0 0 (para o canto superior esquerdo)
# Ou deixar sem opções para o padrão (geralmente centralizado)
"$WLOGOUT_CMD
