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
                --output LVDS1 --off
            xrandr --nograb -d :0.0 --output HDMI2 --auto --left-of HDMI3 \
                --rotate left
            ;;

        undock)
            xrandr --nograb -d :0.0 --output HDMI2 --off
            xrandr --nograb -d :0.0 --output LVDS1 --auto --primary \
                --output HDMI3 --off
            ;;

    esac
}
