#/usr/bin/env bash

STATUS=$(cat /sys/class/power_supply/BAT0/status)

if [[ $STATUS != "Discharging" ]]; then
    sleep 2

    vesktop &
    signal-desktop &
    feishin &
fi