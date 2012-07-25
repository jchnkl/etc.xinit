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

eventHooks['video/brightnessup BRTUP 00000086 00000000 K']='brightnessUpHook brightnessNotification'

eventHooks['video/brightnessdown BRTDN 00000087 00000000 K']='brightnessDownHook brightnessNotification'

# eventHooks['button/volumeup VOLUP 00000080 00000000 K']='volumeIncrease volumeNotification'

# eventHooks['button/volumedown VOLDN 00000080 00000000 K']='volumeDecrease volumeNotification'

function commonHook () {
    # echo "commonHook0 $@"

    setxkbmap -layout 'us' -variant 'altgr-intl' -option 'caps:swapescape'
    xmodmap ~/.Xmodmap
}


function dockHook () {

    if [ "$( dbusSend isDocked )" ]; then
        switchDisplay dock

        pkill xlock
        if [ $? -eq 0 ]; then
            xlock -allowaccess &
        fi
    fi

    commonHook
    pkill xmobar; xmobar -x1 ~/.xmobarrc.phobos.dark &

}


function undockHook () {

    switchDisplay undock
    commonHook
    pkill xmobar; xmobar -x0 ~/.xmobarrc.phobos.dark &

}

function resumeHook () {
    dockHook
    amixer set Master unmute
}

function suspendHook () {
    undockHook
    amixer set Master mute
}

function hibernateHook () {
    undockHook
    amixer set Master mute
}

function sleepKeyHook () {
    xlock -allowaccess &
    dbusSend $1
}

function lidKeyHook () { sleepKeyHook Suspend; }

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

function brightnessHook () {
    step=10

    if [ "$( dbusSend isDocked )" ]; then

        brightness=$( getBrightness )

        if [ $1 = up -a $brightness -lt 100 ]; then
            brightness=$((brightness + step))
        elif [ $1 = down -a $brightness -gt $step ]; then
            brightness=$((brightness - step))
        fi

        setBrightness $brightness

    fi
}

function brightnessUpHook () {
    brightnessHook up
}

function brightnessDownHook () {
    brightnessHook down
}
