#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# ck-launch-session is handled by display manager

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
      dispwin -c -d 1 -I ~/.color/icc/hp_lp2475w_right_lab_relative_colorimetric.icc &
      dispwin -c -d 2 -I ~/.color/icc/hp_lp2475w_left_lab_relative_colorimetric.icc &
      nitrogen --set-auto ${HOME}/.xinit/GrandCanyon.png &
      xmobar -x 1 &
  fi

  xmonad 2>&1 >> ${HOME}/.xmonad/xmonad.log &

  # xfce4-settings-helper &
  exec xfce4-session
