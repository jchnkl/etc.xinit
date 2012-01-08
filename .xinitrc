#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# global (ahem..) variable for all spawned pids
PIDS=

# ck-launch-session is handled by display manager
exec dbus-launch --exit-with-session sh -c '(

  addPID() {
    PIDS="$! ${PIDS}"
  }

  bgService() {
    while [ -n "$1" ]; do
      echo -n "Starting $1.. "
      # $! process ID of most recently background command.
      $1 2>&1>/dev/null & addPID $!
      echo "done"
      shift
    done
  }

  export $(gnome-keyring-daemon -s; addPID $!)

  bgService \
    "setxkbmap -layout 'us' -variant 'altgr-intl' -option 'caps:swapescape'" \
    "xsetroot -cursor_name left_ptr" \
    "xrdb -merge ${HOME}/.Xresources" \
    "urxvtd -q -f -o"
    # "cairo-compmgr -n"

  if [ $(hostname) = "phobos" ]; then
    bgService "wicd-gtk" "xfce4-power-manager" \
      "nitrogen --set-auto /usr/share/backgrounds/DenseClouds.png"
  elif [ $(hostname) = "monolith" ]; then
    bgService "nitrogen --set-auto ${HOME}/.xinit/GrandCanyon.png"
  fi

  xmonad;

  kill ${PIDS}

)'
