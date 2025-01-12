HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

## oh my zsh
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE=true
ZSH_THEME="gallifrey"
plugins=(zsh-autosuggestions zsh-syntax-highlighting git)
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh

## man pager
export MANROFFOPT="-c" 
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

if [[ ! -z "$CONTAINER_ID" ]]; then
    PROMPT="%F{cyan}‹$CONTAINER_ID›%f $PROMPT"
fi

alias ls='eza -al'
alias less='bat'

export PATH=$PATH:/usr/lib/rust-1.77/bin

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
