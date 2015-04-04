#!/bin/bash

# don't load fancy cursor themes
# man 3 Xcursor
export XCURSOR_PATH=

# run the keyring daemon
# all env variables except SSH_AUTH_SOCK are deprecated
# as of gpg-2.2 gnome-keyring-daemon is not supported anymore
# current solution is to keep old gpg installed
eval $(gnome-keyring-daemon -s)
export SSH_AUTH_SOCK

# add non-standard font-path
xset fp +/usr/share/fonts/local

# merge custom settings
xrdb -merge ${HOME}/.Xresources

# fades color temperature to red
redshift -r -v -t 6500:4500 -l 49.452778:11.077778 &

# hides mouse cursor on kbd events
xbanish &

# disable touchpad
synclient TouchpadOff=1

# configure marble mouse
~/.xinitrc.d/xinput.sh

# load custom keymap
xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY

# for generic (wm-independent) keybindings
xbindkeys -p

# run core event handler: https://github.com/jotrk/core.sh
SRCS_D=~/.xinitrc.d/srcs.d/ SINKS_D=~/.xinitrc.d/sinks.d/ core.sh
COREPID=$!

# start the wm
openbox

pkill ${COREPID}
