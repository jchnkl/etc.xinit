#!/bin/bash

case $@ in
  UDEV*change*/devices/pci0000:00/0000:00:02.0/drm/card0\ *)
    nitrogen --restore
    ;;
esac
