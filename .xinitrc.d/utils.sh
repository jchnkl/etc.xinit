#!/bin/sh


function dbusSend () {
    # echo "dbusSend $1"

    function upowerSleep () {
        dbus-send \
            --system \
            --print-reply \
            --type=method_call \
            --dest='org.freedesktop.UPower' \
            '/org/freedesktop/UPower' \
            "org.freedesktop.UPower.$1"
    }

    case "$1" in
        Suspend|Hibernate)
            upowerSleep $1 &
            ;;
        "isDocked")
            dbus-send \
                --system \
                --print-reply \
                --type=method_call \
                --dest='org.freedesktop.UPower' \
                '/org/freedesktop/UPower' \
                'org.freedesktop.DBus.Properties.Get' \
                'string:org.freedesktop.UPower' 'string:IsDocked' \
                | grep true
            ;;
    esac
}


function switchDisplay () {
    # echo "switchDisplay $@"

    case "$1" in
        dock)
            xrandr --nograb -d :0.0 --output HDMI3 --auto --primary \
                --output LVDS1 --off 2>&1 | logger
            xrandr --nograb -d :0.0 --output HDMI2 --auto --left-of HDMI3 \
                --rotate left  2>&1 | logger
            ;;

        undock)
            xrandr --nograb -d :0.0 --output HDMI2 --off 2>&1 | logger
            xrandr --nograb -d :0.0 --output LVDS1 --auto --primary \
                --output HDMI3 --off 2>&1 | logger
            ;;

    esac
}


function getBrightness () {
    xrandr --verbose | grep -m1 Brightness | cut -d ' ' -f 2 | \
        xargs echo "100 * " | bc | cut -d '.' -f 1
}


function setBrightness () {
    brightness=$( echo $1 | xargs echo "scale=2; 1/100 * "  | bc )
    xrandr --output HDMI2 --brightness $brightness \
           --output HDMI3 --brightness $brightness
}
