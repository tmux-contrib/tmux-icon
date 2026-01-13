# tmux-icon

A tmux plugin that displays custom icons (including nerd fonts) for window numbers in the status bar.

## Installation

```tmux
# configure the tmux plugins manager
set -g @plugin "tmux-plugins/tpm"

# official plugins
set -g @plugin 'tmux-contrib/tmux-icon'
```

## Usage

Configure custom icons for window numbers using the `@window-icons` option:

```tmux
# Circled numbers
set -g @window-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"

# Square nerd font icons
set -g @window-icons "󰎣 󰎦 󰎩 󰎬 󰎮 󰎰 󰎵 󰎸 󰎻 󰎾"

# Any custom characters
set -g @window-icons "A B C D E F G H I J"
```

The plugin automatically replaces `#I` (window index) patterns in your status bar with the configured icons.

### Example Configuration

```tmux
# Configure custom icons
set -g @window-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"

# Your existing status bar configuration with #I
set -g window-status-format "#I:#W"
set -g window-status-current-format "#I:#W"

# After the plugin loads, #I will display as custom icons
```

## Configuration Options

| Option          | Description                                           | Default |
|-----------------|-------------------------------------------------------|---------|
| `@window-icons` | Space-separated list of icons for window numbers 0-9 | `""`    |

**Note**: The plugin uses opt-in behavior. If `@window-icons` is not configured (empty default), the plugin does nothing and your tmux options remain unchanged.

## Icon Examples

Here are some popular nerd font icon sets you can use:

```tmux
# Circled numbers (Unicode)
set -g @window-icons "⓪ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨"

# Circled inverted (Nerd Font)
set -g @window-icons "0 󰲠 󰲢 󰲤 󰲦 󰲨 󰲪 󰲬 󰲮 󰲰"

# Square (Nerd Font)
set -g @window-icons "󰎣 󰎦 󰎩 󰎬 󰎮 󰎰 󰎵 󰎸 󰎻 󰎾"

# Square inverted (Nerd Font)
set -g @window-icons "󰎡 󰎤 󰎧 󰎪 󰎭 󰎱 󰎳 󰎶 󰎹 󰎼"

# Layer style (Nerd Font)
set -g @window-icons "󰎢 󰎥 󰎨 󰎫 󰎲 󰎯 󰎴 󰎷 󰎺 󰎽"
```

**Tip**: For best results, use a terminal with a [Nerd Font](https://www.nerdfonts.com/) installed.
