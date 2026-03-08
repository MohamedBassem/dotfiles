#!/usr/bin/env bash
input=$(cat)

host=$(hostname -s)
model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "unknown"')

if [ -n "$remaining" ]; then
  context_str="$(printf '%.0f' "$remaining")% left"
else
  context_str="n/a"
fi

printf '🖥  %s | 🤖 %s | 📊 %s | 📁 %s' "$host" "$model" "$context_str" "$cwd"
