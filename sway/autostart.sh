# ~/.config/sway/autostart.conf

# ╭────────────────────────────────────────────╮
# │               TECLADO LAYOUT
# ╰────────────────────────────────────────────╯
swaymsg 'input "*" xkb_layout br'
swaymsg 'input "*" xkb_variant abnt2'

# ╭────────────────────────────────────────────╮
# │               WALLPAPER                    │
# ╰────────────────────────────────────────────╯
exec swaybg -i ~/.config/sway/wallpapers/guitar.jpg -m fill
