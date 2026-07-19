#!/bin/bash
# Start picom compositor with recommended options
xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output eDP --mode 1920x1080 --pos 0x0 --rotate normal --output VGA-0 --off

# Kill any running instance first (optional)
#killall -q picom

# Wait for processes to terminate
#while pgrep -u $UID -x picom >/dev/null; do sleep 1; done

xcompmgr -c -f &
