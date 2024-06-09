## setting history file to .zhistory
# needed so that history command works
# and zsh autosuggestions plugin works
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

## oh my zsh
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE=true

if [[ -f /.dockerenv ]] || [[ -f /.containerenv ]]; then
	ZSH_THEME="eastwood"
else
	ZSH_THEME="gallifrey"
fi
plugins=(zsh-autosuggestions zsh-syntax-highlighting git)
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh

## man pager
export MANROFFOPT="-c" 
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

## keybindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

function add_to_path() {
    if [[ ( -d $1 || -f $1 ) ]] && [[ ! ":$PATH:" == *":$1:"* ]]; then
        export PATH=$PATH:$1
    fi
}

## miniconda
if [[ -d ~/miniconda3 ]]
then
	. ~/miniconda3/etc/profile.d/conda.sh
fi

add_to_path $HOME/flutter/bin
add_to_path $HOME/.pub-cache/bin
add_to_path $HOME/go/bin
add_to_path /usr/local/go/bin
add_to_path $HOME/.local/bin

# sourcing /etc/os-release to get distro info
if [[ -f /etc/os-release ]]
then
    source /etc/os-release
fi

## android
if [[ -d ~/Android ]]
then
	export ANDROID_SDK_HOME=~/Android
	export ANDROID_SDK_ROOT=~/Android/sdk
	export ANDROID_NDK_HOME=$ANDROID_SDK_HOME/ndk
	export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
fi

## google chrome
if [[ -f /usr/bin/chromium ]]
then
	export CHROME_EXECUTABLE=/usr/bin/chromium
elif [[ -f /usr/bin/chromium-browser ]]
then
    export CHROME_EXECUTABLE=/usr/bin/chromium-browser
fi

## aliases
alias cdp='cd /media/d/Projects'
alias cdmr='cd /media/d/Projects/mr'
alias cdw='cd /media/d/Projects/workbench'
alias ls='eza -al'
alias less='bat'
alias vs='code'
alias vsd='vscode-distrobox'

if [[ ! -f /run/.containerenv ]] && command -v 1password &> /dev/null; then
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/.1password/agent.sock
fi

if [[ -f ~/.zshenv ]]; then
	source ~/.zshenv
fi

unfunction add_to_path
