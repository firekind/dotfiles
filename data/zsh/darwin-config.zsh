if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

function add_to_path() {
    if [[ ( -d $1 || -f $1 ) ]] && [[ ! ":$PATH:" == *":$1:"* ]]; then
        export PATH=$PATH:$1
    fi
}

add_to_path $HOME/development/flutter/bin

unfunction add_to_path
