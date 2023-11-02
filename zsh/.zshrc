## setting history file to .zhistory
# needed so that history command works
# and zsh autosuggestions plugin works
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

## oh my zsh
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE=true
ZSH_THEME="minimal"
plugins=(git)
source $ZSH/oh-my-zsh.sh

## man pager
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

## pywal
if [[ -d ~/.cache/wal ]]
then
	(cat ~/.cache/wal/sequences &)
fi

## miniconda
if [[ -d ~/miniconda3 ]]
then
	. ~/miniconda3/etc/profile.d/conda.sh
fi

## flutter
if [[ -d ~/flutter ]]
then
	export PATH=$PATH:~/flutter/bin
fi
export PATH="$PATH":"$HOME/.pub-cache/bin"

## devcontainer cli
if [[ -d ~/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/cli-bin ]]
then
    export PATH=$PATH:~/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/cli-bin
fi

# sourcing /etc/os-release to get distro info
if [[ -f /etc/os-release ]]
then
    source /etc/os-release
fi

## Lazy loading nvm, to speed up shell startup
NVM_SH_DIR=/usr/share/nvm
NVM_DIR=$HOME/.nvm
if [ -s "$NVM_SH_DIR/nvm.sh" ] && [ -d "$NVM_DIR/versions/node" ]; then
	NODE_GLOBALS=(`find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
	NODE_GLOBALS+=("node")
	NODE_GLOBALS+=("nvm")
	# Lazy-loading nvm + npm on node globals
	load_nvm () {
		[ -s "$NVM_SH_DIR/nvm.sh" ] && \. "$NVM_SH_DIR/nvm.sh"
	}
	# Making node global trigger the lazy loading
	for cmd in "${NODE_GLOBALS[@]}"; do
		eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
	done
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
alias cdp='cd /d/Projects'
alias cdmr='cd /d/Projects/mr'
alias ls='exa -al'
alias less='bat'
alias vs='code'
# alias dock='sh ~/.config/custom-scripts/dock'
# alias undock='sh ~/.config/custom-scripts/dock off'


## plugins
# checking if /etc/os-release ID is fedora
if [[ "$ID" == "fedora" ]]
then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

## starship prompt
# export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
# eval "$(starship init zsh)"
