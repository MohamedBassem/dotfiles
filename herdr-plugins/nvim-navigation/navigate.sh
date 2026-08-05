#!/usr/bin/env bash
set -euo pipefail

direction="${1:?usage: navigate.sh <left|down|up|right>}"
herdr="${HERDR_BIN_PATH:-herdr}"
pane="${HERDR_PANE_ID:-}"

case "$direction" in
  left) vim_key="h" ;;
  down) vim_key="j" ;;
  up) vim_key="k" ;;
  right) vim_key="l" ;;
  *)
    echo "navigate.sh: unknown direction: $direction" >&2
    exit 2
    ;;
esac

# Match the same Vim family used by the old tmux binding. Herdr can report
# more than one foreground process, so inspect the complete foreground chain.
vim_re='^g?(view|l?n?vim?x?)(diff)?$'
is_vim=0

if [ -n "$pane" ] && command -v jq >/dev/null 2>&1; then
  if "$herdr" pane process-info --pane "$pane" 2>/dev/null \
    | jq -e --arg pattern "$vim_re" '
        .result.process_info.foreground_processes[]?.name
        | ascii_downcase
        | select(test($pattern))
      ' >/dev/null 2>&1; then
    is_vim=1
  fi
fi

if [ "$is_vim" -eq 1 ]; then
  # Neovim's native window command is Ctrl-W followed by h/j/k/l. Sending the
  # native sequence keeps this plugin independent of editor-side mappings.
  exec "$herdr" pane send-keys "$pane" "ctrl+w" "$vim_key"
fi

if [ -n "$pane" ]; then
  exec "$herdr" pane focus --direction "$direction" --pane "$pane"
fi

exec "$herdr" pane focus --direction "$direction" --current
