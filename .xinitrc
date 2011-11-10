#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

#exec urxvt -hold -e sh -c 'xmonad & xfce4-panel --sm-client-disable'

#exit 0

exec dbus-launch --exit-with-session sh -c '( \
  export $(gnome-keyring-daemon -s); GKD_PID=$?; \

  setxkbmap -layout 'us' \
  -variant 'altgr-intl' \
  -option 'caps:swapescape'; \

  xsetroot -cursor_name left_ptr; \

  xrdb -merge ${HOME}/.Xresources; \
  urxvtd -q -f -o; \

  bluetooth-applet & BT_PID=$?; \

  if [ $(hostname) = "phobos" ]; then
    wicd-gtk & WICD_PID=$?;
  fi

  xfdesktop & \
  xfce4-panel & \
  xfce4-power-manager & \
  xmonad & \
  xfce4-session; \

  kill ${GKD_PID} ${BT_PID} ${NM_PID} ${WICD_PID} ${GPM_PID} ${GSD_PID} ${XP_PID};
  ) 2>&1 >> ${HOME}/.xsession-errors'
