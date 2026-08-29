# Keep Sorin's prompt compact over SSH. The upstream theme adds user@host.
PROMPT='%F{4}${_prompt_sorin_pwd}%(!. %B%F{1}#%f%b.)${editor_info[keymap]} '

# Print the nth column.
function awkp() {
  awk "{print \$$1}"
}

if [[ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ]]; then
  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  path=($JAVA_HOME/bin(N) $path)
fi
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path=($ANDROID_HOME/platform-tools(N) $ANDROID_HOME/emulator(N) $path)
fi

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Load nvm only when first used.
nvm() {
  unset -f nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

if [[ -f "$HOME/repos/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/repos/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/repos/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/repos/google-cloud-sdk/completion.zsh.inc"
fi
