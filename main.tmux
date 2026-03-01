#!/usr/bin/env bash
set -euo pipefail

[[ -z "${DEBUG:-}" ]] || set -x

# tmux-icon plugin entry point.
#
# This plugin replaces #I (window index) and #F (window flags) patterns
# in tmux status bar options with custom icons (including nerd font icons).
#
# Configuration:
#   set -g @window-index-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"
#   set -g @window-flag-icons "󰖯 󰖰 󰀨 󰂞 󰂛 󰃀 󰍉"

_tmux_icon_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -f "$_tmux_icon_root/scripts/tmux_core.sh" ]] || {
	echo "tmux-icon: missing tmux_core.sh" >&2
	exit 1
}

# shellcheck source=scripts/tmux_core.sh
source "$_tmux_icon_root/scripts/tmux_core.sh"

[[ -f "$_tmux_icon_root/scripts/tmux_icon.sh" ]] || {
	echo "tmux-icon: missing tmux_icon.sh" >&2
	exit 1
}

# shellcheck source=scripts/tmux_icon.sh
source "$_tmux_icon_root/scripts/tmux_icon.sh"

main() {
	_tmux_icon_update_option "window-status-format"
	_tmux_icon_update_option "window-status-current-format"
}

main
