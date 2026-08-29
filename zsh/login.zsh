[[ -z "$PS1" ]] && return

# Compile the completion dump in the background when it changes.
{
  zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    if command mkdir "${zcompdump}.zwc.lock" 2>/dev/null; then
      zcompile "$zcompdump"
      command rmdir "${zcompdump}.zwc.lock" 2>/dev/null
    fi
  fi
} &!
