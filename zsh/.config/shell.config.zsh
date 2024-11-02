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

## direnv
if command -v direnv 2>&1 >/dev/null
then
    eval "$(direnv hook zsh)"
fi

# if in a distrobox, add the distrobox name to the prompt
if [[ ! -z "$CONTAINER_ID" ]]; then
    PROMPT="%F{cyan}‹$CONTAINER_ID›%f $PROMPT"
fi
