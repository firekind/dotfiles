wifi="$(nmcli radio wifi)"

if [ "$wifi" = "enabled" ]; then
	echo ""
else
	echo "airplane"
fi

