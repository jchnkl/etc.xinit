#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

#exec ck-launch-session xmonad
exec ck-launch-session sh -c '( \
  setxkbmap -layout 'us,de' \
  -option 'caps:swapescape' \
  -option 'grp:alt_caps_toggle' \
  -option 'lv3:menu_switch'; \
  xsetroot -cursor_name left_ptr; \

  xrdb -merge ${HOME}/.Xresources; \
  urxvtd -q -f -o; \

  export $(gnome-keyring-daemon); GKD_PID=$?; \
  bluetooth-applet & BT_PID=$?; \
  nm-applet & NM_PID=$?; \
  gnome-power-manager & GPM_PID=$?; \
  gnome-settings-daemon & GSD_PID=$?; \
  xfce4-panel & XP_PID=$?; \
  xmonad; \
  kill ${GKD_PID} ${BT_PID} ${NM_PID} ${GPM_PID} ${GSD_PID} ${XP_PID};
  ) 2>&1 >> ${HOME}/.xsession-errors'
