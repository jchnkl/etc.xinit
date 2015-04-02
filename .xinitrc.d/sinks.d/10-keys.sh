#!/bin/bash

case $@ in
  button/sleep\ SBTN\ *)
    systemctl suspend
    ;;
esac
