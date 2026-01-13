# tmux-icon

A tmux plugin that displays custom icons (including nerd fonts) for window numbers and flags in the status bar.

## Installation

```tmux
# configure the tmux plugins manager
set -g @plugin "tmux-plugins/tpm"

# official plugins
set -g @plugin 'tmux-contrib/tmux-icon'
```

## Usage

Configure custom icons for window numbers using the `@window-index-icons` option:

```tmux
# Circled numbers
set -g @window-index-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"

# Square nerd font icons
set -g @window-index-icons "󰎣 󰎦 󰎩 󰎬 󰎮 󰎰 󰎵 󰎸 󰎻 󰎾"

# Any custom characters
set -g @window-index-icons "A B C D E F G H I J"
```

The plugin automatically replaces `#I` (window index) patterns in your status bar with the configured icons.

### Example Configuration

```tmux
# Configure custom icons
set -g @window-index-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"

# Your existing status bar configuration with #I
set -g window-status-format "#I:#W"
set -g window-status-current-format "#I:#W"

# After the plugin loads, #I will display as custom icons
```

## Configuration Options

| Option               | Description                                           | Default |
|----------------------|-------------------------------------------------------|---------|
| `@window-index-icons`      | Space-separated list of icons for window numbers 0-9 | `""`    |
| `@window-flag-icons` | Space-separated list of icons for window flags       | `""`    |

**Note**: The plugin uses opt-in behavior. If these options are not configured (empty default), the plugin does nothing and your tmux options remain unchanged.

## Window Flags

The plugin also supports custom icons for window flags using the `@window-flag-icons` option. Window flags indicate the state of a window:

- `*` - Current window
- `-` - Last window
- `#` - Activity in window
- `!` - Bell in window
- `~` - Silence in window
- `M` - Marked window
- `Z` - Zoomed window

### Flag Icon Configuration

Provide 7 space-separated icons in the order above:

```tmux
# Configure flag icons
set -g @window-flag-icons "󰖯 󰖰 󰀨 󰂞 󰂛 󰃀 󰍉"
#                           *   -   #   !   ~   M   Z

# Your status bar configuration with #F
set -g window-status-format " #I: #W #F "
set -g window-status-current-format " #I: #W #F "

# After the plugin loads, #F will display as custom icons
```

### Multiple Flags

Windows can have multiple flags simultaneously (e.g., a window that is both current and zoomed will have `*Z`). The plugin handles this by displaying all applicable flag icons with spacing between them for better readability:

```tmux
# Example: Window with multiple flags
# If #F = "*Z" (current + zoomed)
# Output: 󰖯 󰍉 (both current icon and zoom icon with space)

# If #F = "-#" (last window + activity)
# Output: 󰖰 󰀨 (both last icon and activity icon with space)

# If #F = "*#!" (current + activity + bell)
# Output: 󰖯 󰀨 󰂞 (all three icons with spacing)
```

Each flag character that appears in `#F` will display its corresponding icon followed by a space, allowing you to see all active states at once with clear visual separation.

### Combined Window Numbers and Flags

You can use both window icons and flag icons together:

```tmux
# Configure both options
set -g @window-index-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"
set -g @window-flag-icons "󰖯 󰖰 󰀨 󰂞 󰂛 󰃀 󰍉"

# Status bar with both #I and #F
set -g window-status-format " #I:#W #F "
set -g window-status-current-format " #I:#W #F "

# Both patterns will display as custom icons
```

## Icon Examples

### Window Number Icons

Here are some popular nerd font icon sets you can use for window numbers:

```tmux
# Circled numbers (Unicode)
set -g @window-index-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"

# Circled inverted (Nerd Font)
set -g @window-index-icons "0 󰲠 󰲢 󰲤 󰲦 󰲨 󰲪 󰲬 󰲮 󰲰"

# Square (Nerd Font)
set -g @window-index-icons "󰎣 󰎦 󰎩 󰎬 󰎮 󰎰 󰎵 󰎸 󰎻 󰎾"

# Square inverted (Nerd Font)
set -g @window-index-icons "󰎡 󰎤 󰎧 󰎪 󰎭 󰎱 󰎳 󰎶 󰎹 󰎼"

# Layer style (Nerd Font)
set -g @window-index-icons "󰎢 󰎥 󰎨 󰎫 󰎲 󰎯 󰎴 󰎷 󰎺 󰎽"
```

### Window Flag Icons

Here are some suggested icon sets for window flags (in order: `*`, `-`, `#`, `!`, `~`, `M`, `Z`):

```tmux
# Example 1: Status indicators
set -g @window-flag-icons "󰖯 󰖰 󰀨 󰂞 󰂛 󰃀 󰍉"
#                           *   -   #   !   ~   M   Z

# Example 2: Arrow and symbols
set -g @window-flag-icons "▶ ◀ ● ◉ ○ ◆ ◈"

# Example 3: Simple characters
set -g @window-flag-icons "* - # ! ~ M Z"

# You can mix any icons you prefer!
```

**Tip**: For best results, use a terminal with a [Nerd Font](https://www.nerdfonts.com/) installed.
