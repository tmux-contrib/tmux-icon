#!/usr/bin/env bash
# tmux_core.sh — shared library; meant to be sourced, not executed directly.

# Get a tmux option with default fallback
#
# Arguments:
#   $1 - option name
#   $2 - (optional) default value
# Outputs:
#   Option value or default
_tmux_get_option() {
	local option="$1"
	local default="${2:-}"
	local value

	value="$(tmux show-option -gqv "$option" 2>/dev/null)"
	echo "${value:-$default}"
}

# Set a tmux global option
#
# Arguments:
#   $1 - option name
#   $2 - option value
_tmux_set_option() {
	local option="$1"
	local value="$2"

	tmux set-option -g "$option" "$value"
}
