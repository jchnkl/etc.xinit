#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# global (ahem..) variable for all spawned pids
PIDS=

# ck-launch-session is handled by display manager
exec dbus-launch --exit-with-session sh -c '(

  export $(gnome-keyring-daemon -s)

  setxkbmap -layout 'us' -variant 'altgr-intl' -option 'caps:swapescape'
  xsetroot -cursor_name left_ptr
  xrdb -merge ${HOME}/.Xresources
  urxvtd -q -f -o

  if [ $(hostname) = "phobos" ]; then
      xfce4-power-manager &
      nitrogen --set-auto /usr/share/backgrounds/DenseClouds.png
  elif [ $(hostname) = "monolith" ]; then
      nitrogen --set-auto ${HOME}/.xinit/GrandCanyon.png
  fi

  xmonad 2>&1 >> ${HOME}/.xmonad/xmonad.log;

)'
