#!/bin/bash
if [ "$1" == "decrease" ]
then
 	amixer -q set Master 3%- unmute
 	#ICON="/usr/share/icons/Adwaita/16x16/status/audio-volume-low.png"
 	TEXT=$(amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1)%
elif [ "$1" == "increase" ]
then
 	amixer -q set Master 3%+ unmute
 	#ICON="/usr/share/icons/Adwaita/16x16/status/audio-volume-high.png"
 	TEXT=$(amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1)%
elif [ "$1" == "mute" ]
then
 	amixer -q set Master toggle
 	#ICON="/usr/share/icons/Adwaita/16x16/status/audio-volume-muted.png"
 	TEXT=$(amixer sget Master | tail -1 | cut -d' ' -f8 | sed 's/\(\[\|\]\)//g')
else
 	echo "Usage volume [decrease | increase | mute]"
fi

#ID=$(cat ~/.i3/scripts/.dunst_volume)
#echo $ID
#if [[ $ID -gt "0" ]]
#then
# 	dunstify -p -r $ID "Volume: $TEXT" > ~/.i3/scripts/.dunst_volume
#else
# 	dunstify -p "Volume: $TEXT" > ~/.i3/scripts/.dunst_volume
#fi

dunstify "Volume: $TEXT" -r -20
