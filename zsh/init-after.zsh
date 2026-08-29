# Keep Sorin's prompt compact over SSH. The upstream theme adds user@host.
PROMPT='%F{4}${_prompt_sorin_pwd}%(!. %B%F{1}#%f%b.)${editor_info[keymap]} '

# Prefer eza when installed, otherwise use the platform ls.
if (( $+commands[eza] )); then
  alias ls='eza'
  alias ll='eza -la --git'
elif [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -GF'
  alias ll='ls -alhFG'
else
  alias ls='ls -F --color=auto'
  alias ll='ls -alhF'
fi

alias vim='nvim'
alias vi='nvim'

# Print the nth column.
function awkp() {
  awk "{print \$$1}"
}

export EDITOR=nvim
export HGEDITOR=nvim

export GOPATH="$HOME/repos/go"
export BUN_INSTALL="$HOME/.bun"
export VOLTA_HOME="$HOME/.volta"

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
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Initialize fzf before atuin so atuin keeps Ctrl-R.
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

(( $+commands[atuin] )) && eval "$(atuin init zsh --disable-up-arrow)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

export EZA_ICONS_AUTO=1

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

if [[ -f "$HOME/repos/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/repos/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/repos/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/repos/google-cloud-sdk/completion.zsh.inc"
fi

if [[ "$OSTYPE" == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
