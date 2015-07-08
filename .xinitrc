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

# configure display
xrandr --output DVI-I-1 --right-of DP-0 --rotate left

# disable bell
xset b off

# merge custom settings
xrdb -merge ${HOME}/.Xresources

# configure marble mouse
source ${HOME}/.xinitrc.d/xinput.sh

# load custom keymap
xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY

# hides mouse cursor on kbd events
xbanish &
PIDS+=($!)

# run xautolock
xautolock -locker 'xlock -dpmsoff 5' &
PIDS+=($!)

# for generic (wm-independent) keybindings
xbindkeys -n -p &
PIDS+=($!)

# start the wm
openbox

# kill all leftover processes started by this script
pkill -P $$
