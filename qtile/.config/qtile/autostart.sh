#!/bin/bash

nitrogen --restore &
autorandr --change &
ln -s ~/.config/networkmanager-dmenu/config_qtile.ini ~/.config/networkmanager-dmenu/config.ini &
xfce4-power-manager &
