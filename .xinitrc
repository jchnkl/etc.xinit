#!/bin/bash

export XCURSOR_PATH=

eval $(gnome-keyring-daemon -s)
export SSH_AUTH_SOCK

xrdb -l ${HOME}/.Xresources

synclient TouchpadOff=1
~/.xinitrc.d/xinput.sh
xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY

xbindkeys
openbox
