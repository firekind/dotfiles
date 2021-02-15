
## setting history file to .zsh_history
# needed so that history command works
# and zsh autosuggestions plugin works
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

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
NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
	NODE_GLOBALS=(`find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
	NODE_GLOBALS+=("node")
	NODE_GLOBALS+=("nvm")
	# Lazy-loading nvm + npm on node globals
	load_nvm () {
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
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
if [[ -d /usr/bin/google-chrome-stable ]]
then
	export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
fi

## aliases
alias cdu='cd /d/Users/shyam/Documents/University'
alias cdp='cd /d/Users/shyam/Projects'
alias cdd='cd /d/Users/shyam'
alias ls='exa -al'
alias less='bat'

## plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## starship prompt
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(starship init zsh)"
