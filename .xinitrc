#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# ck-launch-session is handled by display manager
#exec dbus-launch --exit-with-session sh -c '(

source /etc/X11/xinit/xinitrc.d/30-dbus

  export $(gnome-keyring-daemon -s)

  xmodmap ~/.Xmodmap &
  setxkbmap -layout 'us' -variant 'altgr-intl' -option 'caps:swapescape'
  xsetroot -cursor_name left_ptr
  xrdb -merge ${HOME}/.Xresources
  urxvtd -q -f -o

  if [ $(hostname) = "phobos" ]; then
      dispwin ~/.color/icc/phobos_screen_0.icc
      xfce4-power-manager &
      nitrogen --set-auto /usr/share/backgrounds/DenseClouds.png &
      xmobar &
  elif [ $(hostname) = "monolith" ]; then
      dispwin -d 1 ~/.color/icc/monolith_screen0_right.icc
      dispwin -d 2 ~/.color/icc/monolith_screen1_left.icc
      nitrogen --set-auto ${HOME}/.xinit/GrandCanyon.png &
      xmobar -x 1 &
  fi

  xmonad 2>&1 >> ${HOME}/.xmonad/xmonad.log &

  # xfce4-settings-helper &
  exec xfce4-session

#)'
