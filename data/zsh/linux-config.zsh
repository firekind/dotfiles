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
add_to_path $HOME/.cargo/bin

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

function calc_sri() {
    if ! command -v openssl 2>&1 >/dev/null
    then
        echo "openssl: command not found"
        return 1
    fi

    if [[ -z "$1" ]]; then
        echo "path to file should be given"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        echo "invalid file path: $1"
        return 1
    fi

    echo $(openssl dgst -sha256 -binary $1 | openssl base64 -A)
}
