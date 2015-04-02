#!/bin/bash

case $@ in
  UDEV*change*/devices/*/AC*)
    AC=$(echo $@ | cut -d' ' -f 4)
    ONLINE=$(cat /sys/${AC}/online)

    if [ "${ONLINE}" == "1" ]; then
      xset -dpms
      xset s off
    else
      xset +dpms
      xset s 120
    fi
    ;;
esac
