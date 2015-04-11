#!/bin/bash

case $@ in
  UDEV*add*/devices/*/input/*\ *)
    NAME="HID 1096:0284"
    HIDRAW=$(echo $@ | cut -d' ' -f 4)

    if [ -f "/sys/${HIDRAW}/name" ]; then
      if [ "$(cat /sys/${HIDRAW}/name)" == "${NAME}" ]; then
        sleep 0.5
        echo "xkbcomp for ${NAME}"
        xkbcomp -I${HOME}/.xkb ${HOME}/.xkb/keymap/default $DISPLAY
      fi
    fi

    # disable the bell
    xset b off

    ;;
esac
