alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias svim='sudo vim'
alias c='clear'
alias tmux="tmux -2"

function g++gl(){
  g++ "$@" -lglut -lGL -lGLU -lGLEW
}
