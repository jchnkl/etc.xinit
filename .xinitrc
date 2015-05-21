#!/bin/bash

source ${HOME}/.xinitrc.d/xinitrc.common

if [ -r ${HOME}/.xinitrc.d/xinitrc.${HOSTNAME} ]; then
  source ${HOME}/.xinitrc.d/xinitrc.${HOSTNAME}
fi
