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
