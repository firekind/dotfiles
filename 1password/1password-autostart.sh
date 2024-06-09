#!/bin/bash

exec > >(systemd-cat -t 1password-autostart -p info) 2> >(systemd-cat -t 1password-autostart -p err)

info() {
    echo $1
}

error() {
    >&2 echo $1
}

info "initialzing"

if [[ $USER -ne "firekind" ]]; then
    error "the script has to be run as the user firekind"
    exit 1
fi

ORIG_1PASS_SOCK=/home/firekind/.1password/agent.sock
NEW_1PASS_SOCK=/run/user/1000/.1password/agent.sock

info "starting up socat redirect"
if [[ ! -d $(dirname $NEW_1PASS_SOCK) ]]; then
    mkdir $(dirname $NEW_1PASS_SOCK)
fi 
socat UNIX-LISTEN:$NEW_1PASS_SOCK,fork UNIX-CONNECT:$ORIG_1PASS_SOCK &

info "starting up 1password"
/opt/1Password/1password --silent
