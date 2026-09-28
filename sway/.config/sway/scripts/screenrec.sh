#!/usr/bin/env sh

# Toggle screen recording with wl-screenrec.
# Usage: screenrec.sh full|region|stop|status

DIR="$HOME/Videos/Screenrecords"
WAYBAR_SIGNAL=8

notify() {
	command -v notify-send >/dev/null && notify-send -a "Screen recorder" "$@"
}

refresh_waybar() {
	pkill -RTMIN+$WAYBAR_SIGNAL waybar
}

is_recording() {
	pgrep -x wl-screenrec >/dev/null
}

stop() {
	pkill -INT -x wl-screenrec
}

record() {
	mkdir -p "$DIR"
	FILE="$DIR/Screenrecord-$(date +%Y-%m-%d_%H-%M-%S).mp4"

	notify "Recording started" "Press the same key again to stop"
	# Refresh waybar once wl-screenrec is running
	(sleep 0.5 && refresh_waybar) &

	# AV1 because the GPU's H.264 encoder is limited to 4096px (ultrawide is 5120px)
	if wl-screenrec --codec av1 --low-power=off --audio -f "$FILE" "$@"; then
		notify "Recording saved" "$FILE"
	else
		[ -s "$FILE" ] || rm -f "$FILE"
		notify -u critical "Recording failed" "See journalctl --user for wl-screenrec errors"
	fi
	refresh_waybar
}

case "$1" in
full)
	if is_recording; then
		stop
		exit 0
	fi
	OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')
	record -o "$OUTPUT"
	;;
region)
	if is_recording; then
		stop
		exit 0
	fi
	GEOMETRY=$(slurp) || exit 0
	record -g "$GEOMETRY"
	;;
stop)
	stop
	;;
status)
	if is_recording; then
		echo '{"text": "● REC", "tooltip": "Recording - click to stop", "class": "recording"}'
	else
		echo '{"text": ""}'
	fi
	;;
*)
	echo "Usage: $0 full|region|stop|status" >&2
	exit 1
	;;
esac
