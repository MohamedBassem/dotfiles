alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias svim='sudo vim'
alias c='clear'

function g++gl(){
  g++ "$@" -lglut -lGL -lGLU -lGLEW
}
