#!/bin/bash

device='Logitech USB Trackball'

accel_profile='Device Accel Profile'
accel_constant_deceleration='Device Accel Constant Deceleration'
accel_adaptive_deceleration='Device Accel Adaptive Deceleration'

wheel_emulation='Evdev Wheel Emulation'
wheel_emulation_axes='Evdev Wheel Emulation Axes'
wheel_emulation_button='Evdev Wheel Emulation Button'
wheel_emulation_inertia='Evdev Wheel Emulation Inertia'

xinput set-button-map "${device}" 1 9 2 4 5 6 7 8 3
xinput set-ptr-feedback "${device}" 0 8 3

xinput set-prop "${device}" "${accel_profile}" 2
xinput set-prop "${device}" "${accel_constant_deceleration}" 1.44
xinput set-prop "${device}" "${accel_adaptive_deceleration}" 1

xinput set-prop "${device}" "${wheel_emulation}" 1
xinput set-prop "${device}" "${wheel_emulation_axes}" 6 7 4 5
xinput set-prop "${device}" "${wheel_emulation_button}" 8
xinput set-prop "${device}" "${wheel_emulation_inertia}" 6
