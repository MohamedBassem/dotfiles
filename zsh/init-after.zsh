# Keep Sorin's prompt compact over SSH. The upstream theme adds user@host.
PROMPT='%F{4}${_prompt_sorin_pwd}%(!. %B%F{1}#%f%b.)${editor_info[keymap]} '

# Print the nth column.
function awkp() {
  awk "{print \$$1}"
}

if [[ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ]]; then
  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
fi
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
fi

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

if [[ -f "$HOME/repos/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/repos/google-cloud-sdk/completion.zsh.inc"
fi
