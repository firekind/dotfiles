#!/bin/sh

insideCircleColor='#00000000'  # blank
D='#ffffffff'  # default
Hl='#00ff00ff'  
textColor='#ffffffff'
#W='#880000bb'  # wrong
W='#ff0000ff'
F=/usr/share/backgrounds/ouroboros.png

if [[ "$1" == "-b" ]]
then
	F=$(cat ~/.cache/wal/wal)
   	convertedFileName=${F##*/}
	
	if [[ ! -d /tmp/lock-images ]]
	then
		mkdir /tmp/lock-images
	fi

	if [[ ! -f /tmp/lock-images/$convertedFileName ]]
	then
		convert $F \
			-resize 1920x -resize 'x1080<' \
			-gravity center -crop 1920x1080+0+0 +repage /tmp/lock-images/$convertedFileName
	fi
	F="/tmp/lock-images/$convertedFileName"
fi

i3lock \
	-t \
	-i $F \
	--indpos="1850:1000"    \
	--insidevercolor=$insideCircleColor   \
	--ringvercolor=$Hl     \
	--insidewrongcolor=$insideCircleColor \
	--ringwrongcolor=$W   \
	--insidecolor=$insideCircleColor      \
	--ringcolor=$textColor        \
	--linecolor=$insideCircleColor        \
	--separatorcolor=$insideCircleColor   \
	--verifcolor=$textColor        \
	--wrongcolor=$textColor        \
	--timecolor=$textColor        \
	--datecolor=$textColor        \
	--layoutcolor=$textColor      \
	--keyhlcolor=$Hl       \
	--bshlcolor=$W        \
	--radius=30	      \
	--force-clock               \
	--datestr="" 	       \
	--veriftext=""		\
	--wrongtext=""		\
	--noinputtext=""	\
	--timestr="%I:%M %p"  \
	--timesize=150         \
	--time-font='simplifica'    \
	--timepos="220:1030"   \

