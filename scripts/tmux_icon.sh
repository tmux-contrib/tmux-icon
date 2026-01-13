#!/usr/bin/env bash

# Window index pattern to replace with custom icons
readonly _TMUX_ICON_PATTERN_WINDOW="#I"

# Get custom icon array from user configuration.
#
# Retrieves the @window-icons option and parses it into an array.
# If not set, returns empty string (plugin will be disabled).
#
# Users can provide any space-separated characters they want:
#   set -g @window-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Space-separated array of icon characters, or empty string
# Returns:
#   0 on success
_tmux_icon_get_window_icons() {
	local icons

	# Get user configuration with empty default (opt-in behavior)
	icons="$(_tmux_get_option "@window-icons" "")"

	# Return the string as-is (caller will parse into array)
	echo "$icons"
}

# Generate a tmux conditional format command for window index.
#
# Creates a series of tmux conditionals that map numeric window indices
# to custom icons. The output format respects the tmux base-index setting,
# starting conditionals from the configured base-index value:
#   #{?#{==:#name,base},icon0,}#{?#{==:#name,base+1},icon1,}...
#
# This logic is ported from example.tmux get_command() function.
#
# Globals:
#   None
# Arguments:
#   $1 - The tmux format variable name (e.g., "I" for #I)
#   $@ - Array of icon characters to map to (starting from base-index)
# Outputs:
#   A tmux conditional format string
# Returns:
#   0 on success
_tmux_icon_get_command() {
	local name="$1"
	local -i base_index
	local -i i

	# Get tmux base-index setting (default 0)
	base_index="$(_tmux_get_option "base-index" "0")"
	i=$base_index
	shift

	for digit in "$@"; do
		echo -n "#{?#{==:#$name,$i},$digit,}"
		i=$((i + 1))
	done
}

# Interpolate #I patterns with custom icon format strings.
#
# Takes a string containing tmux format patterns and replaces #I (window
# index) with conditional format strings that display custom icons.
# If @window-icons is not configured (empty), returns content unchanged.
#
# Globals:
#   _TMUX_ICON_PATTERN_WINDOW - Pattern for window index (#I)
# Arguments:
#   $1 - Content string to interpolate
# Outputs:
#   The interpolated content string, or original if not configured
# Returns:
#   0 on success
_tmux_icon_interpolate() {
	local content="$1"
	local icons
	local command

	# Get the icon array based on user's configuration
	icons="$(_tmux_icon_get_window_icons)"

	# Skip interpolation if not configured (opt-in behavior)
	if [[ -z "$icons" ]]; then
		echo "$content"
		return 0
	fi

	# Parse space-separated string into array
	# shellcheck disable=SC2086
	read -ra icons <<<$icons

	# Generate conditional format command for window index
	command="$(_tmux_icon_get_command "I" "${icons[@]}")"

	# Replace #I pattern with the conditional format string
	content="${content//$_TMUX_ICON_PATTERN_WINDOW/$command}"

	echo "$content"
}

# Update a single tmux option with custom icon interpolation.
#
# Retrieves the current value of the specified tmux option, applies
# custom icon interpolation to any #I patterns, and sets the option
# to the new value.
#
# Globals:
#   None
# Arguments:
#   $1 - The name of the tmux option to update
# Returns:
#   0 on success
_tmux_icon_update_option() {
	local option="$1"
	local option_value
	local new_option_value

	option_value="$(_tmux_get_option "$option")"
	new_option_value="$(_tmux_icon_interpolate "$option_value")"

	_tmux_set_option "$option" "$new_option_value"
}
