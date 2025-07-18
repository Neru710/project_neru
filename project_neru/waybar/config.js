{
  "layer": "top",
  "position": "top",
  "height": 28,
  "modules-left": ["custom/neru", "hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["cpu", "memory", "temperature", "battery", "pulseaudio", "network", "tray"],

  "custom/neru": {
    "format": "󱄅 NERU",
    "tooltip": false
  },

  "clock": {
    "format": " {:%d/%m}  {:%H:%M}",
    "tooltip": true
  },

  "cpu": {
    "format": "󰍛 {usage}%",
    "tooltip": true
  },

  "memory": {
    "format": "󰍛 {used}M",
    "tooltip": true
  },

  "temperature": {
    "format": " {temperatureC}°C",
    "critical-threshold": 80
  },

  "battery": {
    "format": "{capacity}%  ",
    "format-charging": " {capacity}%",
    "tooltip": true
  },

  "pulseaudio": {
    "format": " {volume}%",
    "format-muted": "",
    "tooltip": false
  },

  "network": {
    "format-wifi": " {essid} ({signalStrength}%)",
    "format-ethernet": "󰈀 {ifname}",
    "tooltip": true
  },

  "tray": {
    "icon-size": 18,
    "spacing": 10
  }
}
