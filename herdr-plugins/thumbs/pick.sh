#!/usr/bin/env bash
set -euo pipefail
if [ "${HERDR_THUMBS_DEBUG:-0}" = "1" ]; then
  set -x
fi

herdr="${HERDR_BIN_PATH:-herdr}"
pane="${HERDR_PANE_ID:-}"
state_dir="${HERDR_PLUGIN_STATE_DIR:-${TMPDIR:-/tmp}}"
thumbs_dir="${HERDR_THUMBS_DIR:-${HOME}/.tmux/plugins/tmux-thumbs}"

if [ -z "$pane" ]; then
  echo "thumbs: no focused Herdr pane" >&2
  exit 1
fi

if [ ! -f "$thumbs_dir/Cargo.toml" ]; then
  echo "thumbs: tmux-thumbs checkout not found at $thumbs_dir" >&2
  exit 1
fi

if [ ! -x "$thumbs_dir/target/release/thumbs" ] \
  || [ ! -x "$thumbs_dir/target/release/tmux-thumbs" ]; then
  cargo build --release --manifest-path "$thumbs_dir/Cargo.toml" >&2
fi

mkdir -p "$state_dir"
capture="$(mktemp "${state_dir%/}/thumbs-capture.XXXXXX")"

if ! "$herdr" pane read "$pane" --source visible --format text >"$capture"; then
  rm -f "$capture"
  exit 1
fi

pane_info="$("$herdr" pane get "$pane")"
workspace="$(printf '%s' "$pane_info" | jq -er '.result.pane.workspace_id')"
source_tab="$(printf '%s' "$pane_info" | jq -er '.result.pane.tab_id')"
layout="$("$herdr" pane layout --pane "$pane")"
zoomed="$(printf '%s' "$layout" | jq -r '.result.layout.zoomed')"

open_picker() {
  "$herdr" plugin pane open \
    --plugin "${HERDR_PLUGIN_ID:-mbassem.thumbs}" \
    --entrypoint picker \
    "$@" \
    --env "HERDR_THUMBS_CAPTURE=$capture" \
    --env "HERDR_THUMBS_TARGET_PANE=$pane" \
    --env "HERDR_THUMBS_DIR=$thumbs_dir"
}

# A zoomed pane already occupies the full terminal area, so Herdr's native
# overlay is the exact geometry we want in that case.
if [ "$zoomed" = "true" ]; then
  if ! open_picker --placement overlay --focus >/dev/null; then
    rm -f "$capture"
    exit 1
  fi
  exit 0
fi

# Herdr's native overlay zooms the entire tab. For a normal split, create the
# picker beside the source, move the source to a temporary tab, and let the
# picker collapse into the source's exact former layout rectangle.
ready="$(mktemp "${state_dir%/}/thumbs-ready.XXXXXX")"
if ! opened="$(open_picker \
  --placement split \
  --target-pane "$pane" \
  --direction right \
  --env "HERDR_THUMBS_REPLACE_PANE=1" \
  --env "HERDR_THUMBS_SOURCE_TAB=$source_tab" \
  --env "HERDR_THUMBS_READY=$ready" \
  --no-focus)"; then
  rm -f "$capture" "$ready"
  exit 1
fi

plugin_pane="$(printf '%s' "$opened" | jq -er '.result.plugin_pane.pane.pane_id')"
source_pane="$pane"

restore_source() {
  local attempts=0
  while [ "$attempts" -lt 5 ]; do
    if "$herdr" pane move "$source_pane" \
      --tab "$source_tab" \
      --target-pane "$plugin_pane" \
      --split right \
      --no-focus >/dev/null 2>&1; then
      return 0
    fi
    attempts=$((attempts + 1))
    sleep 0.02
  done
  return 1
}

if ! moved="$("$herdr" pane move "$pane" \
  --new-tab \
  --workspace "$workspace" \
  --label "[thumbs-source]" \
  --no-focus)" \
  || ! printf '%s' "$moved" | jq -e '.result.move_result.changed == true' >/dev/null; then
  "$herdr" plugin pane close "$plugin_pane" >/dev/null 2>&1 || true
  rm -f "$capture" "$ready"
  exit 1
fi

source_pane="$(printf '%s' "$moved" | jq -er '.result.move_result.pane.pane_id')"

if ! "$herdr" plugin pane focus "$plugin_pane" >/dev/null; then
  restore_source || true
  "$herdr" plugin pane close "$plugin_pane" >/dev/null 2>&1 || true
  rm -f "$capture" "$ready"
  exit 1
fi

printf '%s\n' "$source_pane" >"$ready"
