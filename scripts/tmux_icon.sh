#!/usr/bin/env bash

# Window index pattern to replace with custom icons
readonly _TMUX_ICON_PATTERN_WINDOW="#I"

# Window flag pattern to replace with custom icons
readonly _TMUX_ICON_PATTERN_FLAG="#F"

# Get custom icon array from user configuration.
#
# Retrieves the @window-index-icons option and parses it into an array.
# If not set, returns empty string (plugin will be disabled).
#
# Users can provide any space-separated characters they want:
#   set -g @window-index-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"
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
	icons="$(_tmux_get_option "@window-index-icons" "")"

	# Return the string as-is (caller will parse into array)
	echo "$icons"
}

# Get custom icon array for window flags from user configuration.
#
# Retrieves the @window-flag-icons option and parses it into an array.
# If not set, returns empty string (plugin will be disabled).
#
# Users can provide space-separated characters for 7 window flags in order:
#   * (current), - (last), # (activity), ! (bell), ~ (silence), M (marked), Z (zoomed)
#
# Example:
#   set -g @window-flag-icons "󰖯 󰖰 󰀨 󰂞 󰂛 󰃀 󰍉"
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Space-separated array of icon characters, or empty string
# Returns:
#   0 on success
_tmux_icon_get_flag_icons() {
	local icons

	# Get user configuration with empty default (opt-in behavior)
	icons="$(_tmux_get_option "@window-flag-icons" "")"

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

# Generate a tmux conditional format command for window flags.
#
# Creates a series of tmux conditionals that map window flag characters
# to custom icons. Window flags include:
#   * (current), - (last), # (activity), ! (bell), ~ (silence), M (marked), Z (zoomed)
#
# The output format is:
#   #{?#{==:#F,*},icon0,}#{?#{==:#F,-},icon1,}#{?#{==:#F,#},icon2,}...
#
# Globals:
#   None
# Arguments:
#   $@ - Array of icon characters to map to flags (in standard flag order)
# Outputs:
#   A tmux conditional format string
# Returns:
#   0 on success
_tmux_icon_get_flag_command() {
	local flags=("*" "-" "#" "!" "~" "M" "Z")
	local -i i=0

	for flag in "${flags[@]}"; do
		local icon="${1:-}"
		if [[ -z "$icon" ]]; then
			break
		fi
		echo -n "#{?#{==:#F,$flag},$icon,}"
		shift
		i=$((i + 1))
	done
}

# Interpolate #I and #F patterns with custom icon format strings.
#
# Takes a string containing tmux format patterns and replaces:
# - #I (window index) with conditional format strings for window numbers (from @window-index-icons)
# - #F (window flags) with conditional format strings for flag characters (from @window-flag-icons)
#
# If the corresponding option is not configured, that pattern remains unchanged.
#
# Globals:
#   _TMUX_ICON_PATTERN_WINDOW - Pattern for window index (#I)
#   _TMUX_ICON_PATTERN_FLAG - Pattern for window flags (#F)
# Arguments:
#   $1 - Content string to interpolate
# Outputs:
#   The interpolated content string, or original if not configured
# Returns:
#   0 on success
_tmux_icon_interpolate() {
	local content="$1"

	# Handle window index (#I)
	local window_icons="$(_tmux_icon_get_window_icons)"
	if [[ -n "$window_icons" ]]; then
		local -a icons
		# shellcheck disable=SC2086
		read -ra icons <<<$window_icons
		local command="$(_tmux_icon_get_command "I" "${icons[@]}")"
		content="${content//$_TMUX_ICON_PATTERN_WINDOW/$command}"
	fi

	# Handle window flags (#F)
	local flag_icons="$(_tmux_icon_get_flag_icons)"
	if [[ -n "$flag_icons" ]]; then
		local -a icons
		# shellcheck disable=SC2086
		read -ra icons <<<$flag_icons
		local command="$(_tmux_icon_get_flag_command "${icons[@]}")"
		content="${content//$_TMUX_ICON_PATTERN_FLAG/$command}"
	fi

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
