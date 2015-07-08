#!/bin/bash

case $@ in
  UDEV*add*/devices/*/mouse?\ *)
    Logitech="Logitech USB Trackball"
    ThinkPad="Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint"
    HIDRAW=$(echo $@ | cut -d' ' -f 4)
    echo "HIDRAW: ${HIDRAW}" 1>&2

    if [ "$(cat /sys/${HIDRAW}/device/name)" == "${Logitech}" ]; then
      sleep 0.5
      echo "Configuring ${Logitech} .."

      device='Logitech USB Trackball'

      accel_profile='Device Accel Profile'
      accel_constant_deceleration='Device Accel Constant Deceleration'
      accel_adaptive_deceleration='Device Accel Adaptive Deceleration'

      wheel_emulation='Evdev Wheel Emulation'
      wheel_emulation_axes='Evdev Wheel Emulation Axes'
      wheel_emulation_button='Evdev Wheel Emulation Button'
      wheel_emulation_inertia='Evdev Wheel Emulation Inertia'

      xinput set-button-map "${device}" 1 9 2 4 5 6 7 8 3
      xinput set-ptr-feedback "${device}" 0 8 3

      xinput set-prop "${device}" "${accel_profile}" 2
      xinput set-prop "${device}" "${accel_constant_deceleration}" 1.44
      xinput set-prop "${device}" "${accel_adaptive_deceleration}" 1

      xinput set-prop "${device}" "${wheel_emulation}" 1
      xinput set-prop "${device}" "${wheel_emulation_axes}" 6 7 4 5
      xinput set-prop "${device}" "${wheel_emulation_button}" 8
      xinput set-prop "${device}" "${wheel_emulation_inertia}" 6

    elif [ "$(cat /sys/${HIDRAW}/device/name)" == "${ThinkPad}" ]; then
      sleep 0.5
      echo "Configuring ${ThinkPad} .." 1>&2
      if [ -f /sys/${HIDRAW}/device/sensitivity ]; then
        echo 255 | sudo tee -a /sys/${HIDRAW}/device/device/sensitivity
      fi
    fi
    ;;

esac
