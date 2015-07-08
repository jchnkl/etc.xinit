#!/bin/bash

case $@ in
  UDEV*add*/devices/*/input/*\ *)
    Noppoo1="HID 1097:0284"
    Noppoo2="HID 1007:0600"
    ThinkPad="Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint"
    HIDRAW=$(echo $@ | cut -d' ' -f 4)

    if [ -f "/sys/${HIDRAW}/name" ]; then
      if [ "$(cat /sys/${HIDRAW}/name)" == "${Noppoo1}" ]; then
        sleep 0.5
        echo "Configuring ${Noppoo1} .."
        xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY
      elif [ "$(cat /sys/${HIDRAW}/name)" == "${Noppoo2}" ]; then
        sleep 0.5
        echo "Configuring ${Noppoo2} .."
        xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY
      elif [ "$(cat /sys/${HIDRAW}/name)" == "${ThinkPad}" ]; then
        sleep 0.5
        echo "Configuring ${ThinkPad} .."
        setxkbmap -option 'caps:swapescape'
        xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY
      fi
    fi

    # disable the bell
    xset b off

    ;;
esac
