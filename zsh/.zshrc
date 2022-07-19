## setting history file to .zhistory
# needed so that history command works
# and zsh autosuggestions plugin works
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

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
fi

## aliases
alias cdu='cd /d/Users/shyam/Documents/University'
alias cdp='cd /d/Users/shyam/Projects'
alias cdd='cd /d/Users/shyam'
alias ls='exa -al'
alias less='bat'
alias composer='bash ~/.config/custom-scripts/composer'
# alias dock='sh ~/.config/custom-scripts/dock'
# alias undock='sh ~/.config/custom-scripts/dock off'


## plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## starship prompt
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(starship init zsh)"

eval $(thefuck --alias)
export HOSTNAME=$HOST


# bun completions
[ -s "/home/firekind/.bun/_bun" ] && source "/home/firekind/.bun/_bun"

# bun
export BUN_INSTALL="/home/firekind/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
