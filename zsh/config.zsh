function add_to_path() {
    if [[ ( -d $1 || -f $1 ) ]] && [[ ! ":$PATH:" == *":$1:"* ]]; then
        export PATH=$PATH:$1
    fi
}

add_to_path $HOME/flutter/bin
add_to_path $HOME/.pub-cache/bin
add_to_path $HOME/go/bin
add_to_path /usr/local/go/bin
add_to_path $HOME/.local/bin

unfunction add_to_path

## setting __distrobox_bin variable to point to the
## original distrobox binary. if not found, intializes
## it to distrobox
if command -v distrobox 2>&1 >/dev/null
then
    __distrobox_bin=$(which distrobox)
else
    __distrobox_bin="distrobox"
fi
