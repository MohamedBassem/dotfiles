# Herdr plugins

These plugins live in the dotfiles checkout. Home Manager registers them with
`herdr plugin link` during activation.

## Neovim navigation

`prefix+h/j/k/l` inspects the focused pane. When Neovim is in the foreground,
the plugin sends its native `Ctrl-W h/j/k/l` window command. The Neovim mapping
moves to an editor window when one exists and asks Herdr to move to its
neighboring pane at the outer editor edge. For other foreground processes, the
Herdr action moves directly to the neighboring pane. It uses the `jq` package
from the shared Home Manager profile for process detection.

## Thumbs

`prefix+space` captures the visible pane and temporarily replaces that pane's
exact layout slot with the hint UI. The original terminal is parked in a
temporary tab and restored when the picker exits; surrounding panes do not
resize. Already-zoomed panes use Herdr's native fullscreen overlay.
It runs the existing `thumbs` matcher/renderer and `tmux-thumbs` socket sender
from `~/.tmux/plugins/tmux-thumbs/target/release`, so matching, hint assignment,
colors, and interaction stay on the same Rust implementation as tmux. Set
`HERDR_THUMBS_DIR` before starting Herdr to use another checkout. Missing
release binaries are built automatically with Cargo.

- Type a lowercase hint to copy it.
- Type the final hint letter uppercase to copy and paste it into the source pane.
- Press Space to enter multi-select; select hints, then press Space again to
  copy and paste the values joined by spaces.
- Arrow keys change the selected match, Enter selects it, and Escape cancels.

Clipboard writes use OSC 52, which Herdr forwards to the attached client.
