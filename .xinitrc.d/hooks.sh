#!/bin/bash

source ~/.xinitrc.d/utils.sh
source ~/.xinitrc.d/brightnessHandler.sh
# source ~/.xinitrc.d/volumeHandler.sh

eventHooks['NotifySleep']='suspendHook'

eventHooks['NotifyResume']='resumeHook'

# Dock Key Event
eventHooks['ibm/hotkey LEN0068:00 00000080 00004010']='dockHook'

# Undock Key Event
eventHooks['ibm/hotkey LEN0068:00 00000080 00004011']='undockHook'

# Fn + F4
eventHooks['button/sleep SBTN 00000080 00000000 K']='suspendKeyHook'

# Fn + F12
eventHooks['button/suspend SUSP 00000080 00000000 K']='' # hibernateKeyHook

# (close|open)
eventHooks['button/lid LID close']='lidKeyHook'

# Fn + F7
eventHooks['video/switchmode VMOD 00000080 00000000 K']='displaySwitchKey'

eventHooks['video/brightnessup BRTUP 00000086 00000000 K']='' # 'brightnessUpHook brightnessNotification'

eventHooks['video/brightnessdown BRTDN 00000087 00000000 K']='' # 'brightnessDownHook brightnessNotification'

eventHooks['button/volumeup VOLUP 00000080 00000000 K']=''

eventHooks['button/volumedown VOLDN 00000080 00000000 K']=''

eventHooks['button/screenlock SCRNLCK 00000080 00000000 K']='xlock'

function commonHook () {
    # echo "commonHook0 $@"
    setxkbmap -layout 'us' -variant 'altgr-intl' -option 'caps:swapescape'
    xmodmap ~/.Xmodmap
}


function dockHook () {
    switchDisplay dock
    xrandr --output HDMI2 --brightness 1 --output HDMI3 --brightness 1

    pkill xlock
    if [ $? -eq 0 ]; then
        xlock -allowaccess &
    fi

    commonHook
    pkill xmobar; xmobar -x1 ~/.xmobarrc.phobos.dark &!
}


function undockHook () {
    switchDisplay undock
    xrandr --verbose --output LVDS1 --brightness 1
    commonHook
    pkill xmobar; xmobar -x0 ~/.xmobarrc.phobos.dark &!
}

function resumeHook () { if [ "$( dbusSend isDocked )" ]; then dockHook; fi; }

function suspendHook () { undockHook; }

# function hibernateHook () { suspendHook; }

function sleepKeyHook () {
    xlock -allowaccess &
    dbusSend $1
}

function lidKeyHook () { suspendKeyHook; }

function suspendKeyHook () { sleepKeyHook Suspend; }

function hibernateKeyHook () { dbusSend Hibernate; }

function displaySwitchKey () {
    if [ "$( dbusSend isDocked )" ]; then
        undockHook
        dockHook
    else
        dockHook
        undockHook
    fi
}
