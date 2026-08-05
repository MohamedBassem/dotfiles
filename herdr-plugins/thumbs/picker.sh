#!/usr/bin/env bash
set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
capture="${HERDR_THUMBS_CAPTURE:?thumbs: HERDR_THUMBS_CAPTURE is not set}"
target_pane="${HERDR_THUMBS_TARGET_PANE:-}"
thumbs_dir="${HERDR_THUMBS_DIR:-${HOME}/.tmux/plugins/tmux-thumbs}"
thumbs="$thumbs_dir/target/release/thumbs"
sender="$thumbs_dir/target/release/tmux-thumbs"
state_dir="${HERDR_PLUGIN_STATE_DIR:-${TMPDIR:-/tmp}}"
replace_pane="${HERDR_THUMBS_REPLACE_PANE:-0}"
source_tab="${HERDR_THUMBS_SOURCE_TAB:-}"
ready="${HERDR_THUMBS_READY:-}"
own_pane="${HERDR_PANE_ID:-}"

mkdir -p "$state_dir"
result="$(mktemp "${state_dir%/}/thumbs-result.XXXXXX")"
input_socket="$(mktemp "${state_dir%/}/thumbs-input.XXXXXX")"
old_stty=""
thumbs_pid=""

cleanup() {
  local attempts=0

  if [ -n "$thumbs_pid" ] && kill -0 "$thumbs_pid" 2>/dev/null; then
    kill "$thumbs_pid" 2>/dev/null || true
    wait "$thumbs_pid" 2>/dev/null || true
  fi
  if [ -n "$old_stty" ]; then
    stty "$old_stty" </dev/tty 2>/dev/null || true
  fi

  # Put the original terminal back into this layout slot. Once this plugin
  # process exits, Herdr removes its pane and the source expands to the exact
  # rectangle it had before Thumbs opened.
  if [ "$replace_pane" = "1" ] \
    && [ -n "$target_pane" ] \
    && [ -n "$source_tab" ] \
    && [ -n "$own_pane" ]; then
    while [ "$attempts" -lt 5 ]; do
      if "$herdr" pane move "$target_pane" \
        --tab "$source_tab" \
        --target-pane "$own_pane" \
        --split right \
        --no-focus >/dev/null 2>&1; then
        break
      fi
      attempts=$((attempts + 1))
      sleep 0.02
    done
  fi

  printf '\033[0m\033[?25h'
  rm -f "$capture" "$result" "$input_socket"
  if [ -n "$ready" ]; then
    rm -f "$ready"
  fi
}
trap cleanup EXIT
trap 'exit 130' HUP INT TERM

if [ ! -x "$thumbs" ] || [ ! -x "$sender" ]; then
  echo "thumbs: release binaries not found under $thumbs_dir" >&2
  exit 1
fi

if [ "$replace_pane" = "1" ]; then
  while [ ! -s "$ready" ]; do
    sleep 0.01
  done
  IFS= read -r target_pane <"$ready"
fi

# The Rust matcher consumes the Herdr capture on stdin, renders directly into
# this overlay, and listens for the same socket events as the tmux integration.
"$thumbs" \
  --format '%U:%H' \
  --target "$result" \
  --input-socket "$input_socket" \
  <"$capture" &
thumbs_pid="$!"

while [ ! -S "$input_socket" ]; do
  if ! kill -0 "$thumbs_pid" 2>/dev/null; then
    wait "$thumbs_pid" || true
    exit 0
  fi
  sleep 0.01
done

old_stty="$(stty -g </dev/tty)"
stty raw -echo </dev/tty

while kill -0 "$thumbs_pid" 2>/dev/null; do
  key=""
  # The timeout lets us notice that the Rust process exited after a completed
  # hint instead of blocking for one extra keypress.
  if ! IFS= read -r -s -n 1 -t 0.05 key </dev/tty; then
    continue
  fi

  event=""
  case "$key" in
    $'\003') event="esc" ;;
    $'\010' | $'\177') event="backspace" ;;
    "") event="enter" ;;
    " ") event="space" ;;
    $'\033')
      second=""
      third=""
      if IFS= read -r -s -n 1 -t 0.02 second </dev/tty \
        && [ "$second" = "[" ] \
        && IFS= read -r -s -n 1 -t 0.02 third </dev/tty; then
        case "$third" in
          A) event="up" ;;
          B) event="down" ;;
          C) event="right" ;;
          D) event="left" ;;
          *) event="esc" ;;
        esac
      else
        event="esc"
      fi
      ;;
    [a-zA-Z]) event="hint:$key" ;;
  esac

  if [ -n "$event" ]; then
    "$sender" --input-socket "$input_socket" --send-input "$event" 2>/dev/null || break
  fi
done

wait "$thumbs_pid" || true
stty "$old_stty" </dev/tty
old_stty=""

if [ ! -s "$result" ]; then
  exit 0
fi

selected=""
paste=0
count=0
while IFS=: read -r upcase value || [ -n "${upcase}${value}" ]; do
  if [ "$count" -gt 0 ]; then
    selected="$selected $value"
  else
    selected="$value"
  fi
  if [ "$upcase" = "true" ]; then
    paste=1
  fi
  count=$((count + 1))
done <"$result"

if [ "$count" -gt 1 ]; then
  paste=1
fi

# Herdr recognizes pane-originated OSC 52 and forwards it to the attached
# client's clipboard, including remote attaches.
encoded="$(printf '%s' "$selected" | base64 | tr -d '\n')"
printf '\033]52;c;%s\a' "$encoded"

if [ "$paste" -eq 1 ] && [ -n "$target_pane" ]; then
  "$herdr" pane send-text "$target_pane" "$selected" >/dev/null
fi
