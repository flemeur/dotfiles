#!/bin/bash
#
# waybar-thinkpad-fan.sh
#
# A script to display the average fan speed of a ThinkPad for Waybar.
# It dynamically finds the correct hwmon directory.
#
# Outputs JSON for Waybar's custom module:
# {
#   "text": " AVG_RPM",
#   "tooltip": "Fan 1: FAN1_RPM\nFan 2: FAN2_RPM",
#   "class": "fan-speed"
# }

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Set this to true if you want to see thousands separators (e.g., 4,566 instead of 4566)
# Requires `numfmt` from coreutils.
USE_THOUSANDS_SEPARATOR=true

# --- Script ---

# Find the hwmon directory that contains fan speed inputs.
# This makes the script more robust if the hwmon number changes between boots.
HWMON_DIR=$(find /sys/devices/platform/thinkpad_hwmon/hwmon/ -type f -name "fan1_input" -print0 2>/dev/null | xargs -0 dirname 2>/dev/null || true)

# Exit gracefully if the directory isn't found.
# The `|| true` above prevents `set -e` from exiting if find/xargs fails.
# We handle the error case manually below.
if [ -z "$HWMON_DIR" ]; then
	# Output a JSON object with an error message for Waybar.
	echo '{"text": "N/A", "tooltip": "Fan sensor path not found. Is thinkpad_acpi loaded?"}'
	exit 1
fi

FAN1_PATH="$HWMON_DIR/fan1_input"
FAN2_PATH="$HWMON_DIR/fan2_input"

# Check if the fan speed files exist.
if [ ! -f "$FAN1_PATH" ] || [ ! -f "$FAN2_PATH" ]; then
	echo '{"text": "N/A", "tooltip": "Could not read fan speed files in '"$HWMON_DIR"'"}'
	exit 1
fi

# Read fan speeds into variables.
fan1_speed=$(cat "$FAN1_PATH")
fan2_speed=$(cat "$FAN2_PATH")

# Check if the values are valid numbers.
if ! [[ "$fan1_speed" =~ ^[0-9]+$ ]] || ! [[ "$fan2_speed" =~ ^[0-9]+$ ]]; then
	echo '{"text": "ERR", "tooltip": "Invalid fan speed value read from sensor."}'
	exit 1
fi

# Calculate the average speed using integer arithmetic.
avg_speed=$(((fan1_speed + fan2_speed) / 2))

# Format numbers with thousands separators if enabled and available.
if [ "$USE_THOUSANDS_SEPARATOR" = true ] && command -v numfmt &>/dev/null; then
	fan1_formatted=$(numfmt --grouping "$fan1_speed")
	fan2_formatted=$(numfmt --grouping "$fan2_speed")
	avg_formatted=$(numfmt --grouping "$avg_speed")
else
	fan1_formatted=$fan1_speed
	fan2_formatted=$fan2_speed
	avg_formatted=$avg_speed
fi

# Use printf to safely escape characters and format the JSON output for Waybar.
printf '{"text": "%s", "tooltip": "Fan 1: %s RPM\\nFan 2: %s RPM", "class": "fan-speed"}\n' "$avg_formatted" "$fan1_formatted" "$fan2_formatted"
