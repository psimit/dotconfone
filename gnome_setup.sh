#!/bin/bash

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 12
for i in {1..9}; do 
  gsettings set "org.gnome.shell.keybindings" "switch-to-application-${i}" "[]"
  gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-${i}" "['<Super>${i}']"
  gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-${i}" "['<Super><Shift>${i}']"
  gsettings set "org.gnome.shell.extensions.dash-to-dock" "app-hotkey-${i}" "[]"
done

gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-10" "['<Super>0']"
gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-10" "['<Super><Shift>0']"

for i in {1..2}; do 
  gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-1${i}" "['<Super><Ctrl>${i}']"
  gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-1${i}" "['<Super><Shift><Ctrl>${i}']"
done

gsettings set org.gnome.desktop.wm.preferences focus-mode 'mouse'