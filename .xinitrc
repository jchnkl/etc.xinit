#!/bin/bash

if [ -r ${HOME}/.xinitrc.d/xinitrc.${HOSTNAME} ]; then
  source ${HOME}/.xinitrc.d/xinitrc.${HOSTNAME}
fi
