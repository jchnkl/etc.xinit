#!/bin/bash

declare -a PIDS

function kill_pids()
{
  for PID in ${PIDS[@]}; do
    kill ${PID}
  done
}

trap "kill_pids" EXIT

# don't load fancy cursor themes
# man 3 Xcursor
export XCURSOR_PATH=

# run the keyring daemon
# as of gnupg-2.1 gnome-keyring-daemon is not supported anymore
# current solution is to keep old gnupg (<= 2.0) installed
gnome-keyring-daemon --start --foreground --components=secrets &
PIDS+=($!)

# disable bell
xset b off

# add non-standard font-path
xset fp+ /usr/share/fonts/local

# merge custom settings
xrdb -merge ${HOME}/.Xresources

# fades color temperature to red
redshift -r -v -t 6500:4500 -l 49.452778:11.077778 &
PIDS+=($!)

# hides mouse cursor on kbd events
xbanish &
PIDS+=($!)

# disable touchpad
synclient TouchpadOff=1

# configure marble mouse
~/.xinitrc.d/xinput.sh

# load custom keymap
xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY

# for generic (wm-independent) keybindings
xbindkeys -n -p &
PIDS+=($!)

# run core event handler: https://github.com/jotrk/core.sh
SRCS_D=~/.xinitrc.d/srcs.d/ SINKS_D=~/.xinitrc.d/sinks.d/ ~/.local/bin/core.sh &
PIDS+=($!)

# start compositing manager
compton &
PIDS+=($!)

# start the wm
openbox

# kill all leftover processes started by this script
pkill -P $$
