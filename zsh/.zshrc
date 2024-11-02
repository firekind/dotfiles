# setting history file to .zhistory
# needed so that history command works
# and zsh autosuggestions plugin works
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

## aliases
alias cdp='cd /media/d/Projects'
alias cdmr='cd /media/d/Projects/mr'
alias cdw='cd /media/d/Projects/workbench'
alias ls='eza -al'
alias less='bat'
alias vs='code'
alias vsd='vscode-distrobox'

if [[ -f $HOME/.config/shell.config.zsh ]]; then
    source $HOME/.config/shell.config.zsh
fi
