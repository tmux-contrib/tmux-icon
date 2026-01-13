#!/usr/bin/env bash

# tmux-icon plugin entry point.
#
# This plugin replaces #I (window index) patterns in tmux status bar
# options with custom icons (including nerd font icons).
#
# Configuration:
#   set -g @window-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"
#
# The @window-icons option accepts a space-separated string of custom
# characters to use for window numbers 0-9. If not set, the plugin
# does nothing (opt-in behavior).
#
# Examples:
#   # Circled numbers
#   set -g @window-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"
#
#   # Square nerd font icons
#   set -g @window-icons "󰎣 󰎦 󰎩 󰎬 󰎮 󰎰 󰎵 󰎸 󰎻 󰎾"
#
#   # Any custom characters
#   set -g @window-icons "A B C D E F G H I J"
#
# Usage:
#   Before: set -g window-status-format "#I:#W"
#   After:  Window numbers display with your custom icons

_tmux_root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/tmux_core.sh
source "$_tmux_root_dir/scripts/tmux_core.sh"

# shellcheck source=scripts/tmux_icon.sh
source "$_tmux_root_dir/scripts/tmux_icon.sh"

# Main entry point for the plugin.
#
# Initializes the tmux-icon plugin by updating all tmux options that
# may contain #I (window index) patterns with custom icons
# based on the @window-icons configuration.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0 on success
main() {
	_tmux_icon_update_option "window-status-format"
	_tmux_icon_update_option "window-status-current-format"
}

main
