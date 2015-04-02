#!/bin/bash

case $@ in
  UDEV*change*/devices/pci0000:00/0000:00:02.0/drm/card0\ *)
    DP3_STATUS=$(< /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-DP-3/status)
    DP3_ENABLED=$(< /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-DP-3/enabled)
    HDMI2_STATUS=$(< /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-HDMI-A-2/status)
    HDMI2_ENABLED=$(< /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-HDMI-A-2/enabled)
    LVDS1_STATUS=$(< /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/status)
    LVDS1_ENABLED=$(< /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/enabled)

    if [ "${DP3_STATUS}" == "connected" ]; then
      echo "xrandr --output DP3 --auto --primary"
      xrandr --output DP3 --auto --primary
    elif [ "${DP3_STATUS}" == "disconnected" ]; then
      echo "xrandr --output DP3 --off"
      xrandr --output DP3 --off
      xrandr --output LVDS1 --auto --primary
    fi

    if [ "${HDMI2_STATUS}" == "connected" ]; then
      echo "xrandr --output DP3 --auto --primary"
      xrandr --output LVDS1 --off
      xrandr --output HDMI2 --right-of DP3 --rotate left --auto
    elif [ "${DP3_STATUS}" == "disconnected" ]; then
      echo "xrandr --output DP3 --off"
      xrandr --output HDMI2 --off
      xrandr --output LVDS1 --auto --primary
    fi

    ;;
esac
