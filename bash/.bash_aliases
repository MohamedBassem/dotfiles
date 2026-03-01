alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias svim='sudo vim'
alias c='clear'
alias tmux="tmux -2"

function g++gl(){
  g++ "$@" -lglut -lGL -lGLU -lGLEW
}

function swap(){
  local TMPFILE=tmp.$$
  mv "$1" $TMPFILE
  mv "$2" "$1"
  mv $TMPFILE "$2"
}

function xopen(){
  xdg-open $1 > /dev/null 2>&1
}
