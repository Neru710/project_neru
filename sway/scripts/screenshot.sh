#!/bin/bash
# tira print da área selecionada e copia pro clipboard
grim - | wl-copy
# cria arquivo temporário pra edição
tmpfile=$(mktemp /tmp/screenshot-XXXXXX.png)
wl-paste > "$tmpfile"
swappy -f "$tmpfile"
