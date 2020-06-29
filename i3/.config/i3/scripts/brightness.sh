#!/bin/bash
if [ "$1" == "inc" ] 
then
	light -A 10
elif [ "$1" == "dec" ] 
then	
	light -U 10
else
	echo "usage: brightness [inc | dec]"
fi

TEXT=$(light -G | cut -d '.' -f 1)
dunstify "Brightness: $TEXT%"  -r -10


# if the brightness doesnt change, add the following udev rules to allow
# users of group 'video' to change brightness (by default, only root can 
# change brightness)
# >>> cat /etc/udev/rules.d/backlight.rules
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="<vendor>", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="<vendor>", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
# then add the user to the group video
# usermod -aG video <user>