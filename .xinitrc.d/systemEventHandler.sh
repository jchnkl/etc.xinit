#!/bin/bash

declare -A eventHooks

HOOKS=${HOME}/.xinitrc.d/hooks.sh

source ${HOME}/.xinitrc.d/utils.sh

trap stopJobs SIGINT SIGHUP SIGUSR1

function stopJobs () { for pid in $(jobs -p); do kill -SIGUSR1 $pid; done; }


function dbus_monitor_watcher () {

    sender='org.freedesktop.UPower'
    interface='org.freedesktop.UPower'

    coproc dbus-monitor \
        --profile \
        --system \
        "type='signal',sender=$sender,interface=$interface"

    function kill_coproc () { kill $COPROC_PID; }
    trap kill_coproc SIGUSR1

    while read -u ${COPROC[0]}; do

        REPLY=$( echo $REPLY | cut -d' ' -f7 )

        if [ -f ${HOOKS} ]; then
            source ${HOOKS}
        else
            continue
        fi

        for f in ${eventHooks[$REPLY]}; do
            eval $f
        done

    done
}


function acpi_listen_watcher () {

    coproc acpi_listen

    function kill_coproc () { kill $COPROC_PID; }
    trap kill_coproc SIGUSR1

    while read -u ${COPROC[0]}; do

        if [ -f ${HOOKS} ]; then
            source ${HOOKS}
        else
            continue
        fi

        for f in ${eventHooks[$REPLY]}; do
            eval $f
        done

    done
}

acpi_listen_watcher &
dbus_monitor_watcher &

wait
