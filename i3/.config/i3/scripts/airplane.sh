#!/bin/bash

wifi="$(nmcli radio wifi)"

if [ "$wifi" = "enabled" ]; then
	dunstify "airplane mode on" -r -10 
	nmcli radio wifi off
else
	dunstify "airplane mode off" -r -10
	nmcli radio wifi on
fi
