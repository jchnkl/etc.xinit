#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# ck-launch-session is handled by display manager

source /etc/X11/xinit/xinitrc.d/30-dbus

export $(gnome-keyring-daemon -s)

setxkbmap -layout 'us' -variant 'altgr-intl' -option 'caps:swapescape'
# xmodmap before setxkbmap will give you a baaad time:
# setxkbmap is the successor of xmodmap and thus overwrite any rules
xmodmap ~/.Xmodmap
xsetroot -cursor_name left_ptr
xset s off -dpms
xrdb -merge ${HOME}/.Xresources
urxvtd -q -f -o

# for xinitscript in ~/.xinitrc.d/*; do
    # if [ -x ${xinit} ]; then
        # source ${xinitscript}
    # fi
# done

~/.xinitrc.d/systemEventHandler.sh &

if [ $(hostname) = "phobos" ]; then
    dispwin ~/.color/icc/phobos_screen_0.icc
    PATH=~/.local/bin:${PATH}; xfce4-power-manager &
    nitrogen --set-auto /usr/share/backgrounds/DenseClouds.png &
    xmobar ${HOME}/.xmobarrc.phobos.dark &
    # xmobar ${HOME}/.xmobarrc.phobos.light &
elif [ $(hostname) = "monolith" ]; then
    dispwin -c -d 1 -I ~/.color/icc/hp_lp2475w_right_lab_relative_colorimetric.icc &
    dispwin -c -d 2 -I ~/.color/icc/hp_lp2475w_left_lab_relative_colorimetric.icc &
    nitrogen --set-auto ${HOME}/.xinit/GrandCanyon.png &
    xmobar -x 1 ${HOME}/.xmobarrc.monolith &
fi

xmonad 2>&1 >> ${HOME}/.xmonad/xmonad.log &

# xfce4-settings-helper &
exec xfce4-session
