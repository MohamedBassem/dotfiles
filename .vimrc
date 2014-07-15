
""""""""""""""""""""""" Vundle Configuration """"""""""""""""""""""""""""""""""""

syntax on

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Bundle 'altercation/vim-colors-solarized'
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'plasticboy/vim-markdown'
Bundle 'mbbill/undotree'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'scrooloose/nerdcommenter'
Bundle 'matze/vim-move'
Bundle 'ervandew/supertab'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'ervandew/snipmate.vim'
Bundle 'tpope/vim-rails'
Bundle 'bling/vim-bufferline'
Bundle 'gcmt/wildfire.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

""""""""""""""""""""""""""""""""""  General  """"""""""""""""""""""""""""""""""""""""

set mouse=a

set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

set pastetoggle=<F2>           " pastetoggle (sane indentation on pastes)

set nu    " Show line numbers

set nolist

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" Tabs sizes
set shiftwidth=2                " Use indents of 4 spaces
set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent

set ai "Auto indent
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set si "Smart indent
set nowrap "Don't Wrap lines

set history=700

" while typing a command, show it in the bottom right corner
set showcmd

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" fast save
nmap <leader>w :w!<cr>

" Root Save
command! W w !sudo tee % > /dev/null


" cursor padding
set so=3

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=.git\*,.hg\*,.svn\*
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/cache/*

set autowrite

set autoread

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2


" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 

" Add a bit extra margin to the left
set foldcolumn=1

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all

if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
      set clipboard=unnamed
    endif
endif

inoremap <C-v> <ESC>"+p`]a

" Black hole deletion/change (persist yanked lines in non-visual mode)
nnoremap d "_d
nnoremap dd "_dd
nnoremap D "_D
nnoremap c "_c
nnoremap C "_C
nnoremap x "_x

"""""""""""""""""""""""""" Colors """""""""""""""""""""""""""""""""""""""""""""
set background=dark
color Tomorrow-Night

let g:indent_guides_auto_colors = 0 
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=black ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey ctermbg=darkgrey

"if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
"    let g:solarized_termcolors=256
"    let g:solarized_termtrans=1
"    let g:solarized_contrast="normal"
"    let g:solarized_visibility="normal"
"    color solarized             " Load a colorscheme
"endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine

"""""""""""""""""""""""""" Key Mappings """"""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""" Moving Around """""""""""""""""""""""""""""""""""""""""


" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>


" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Some helpers to edit mode
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%

set hidden
map <leader>l :bnext<CR>
map <leader>h  :bprevious<CR>
map <leader>bd    :bdelete<CR>
map <leader>bf     :bdelete!<CR>
map <leader>t :enew<CR>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


""""""""""""""""""""""""""" Status Line """""""""""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

""""""""""""""""""""""""""" Others """""""""""""""""""""""""""""""""""""""""""""

au BufRead,BufNewFile *.rabl setfiletype ruby
au BufRead,BufNewFile *.angular setfiletype html

autocmd FileType C      call CPPSET()
autocmd FileType cc     call CPPSET()
autocmd FileType cpp    call CPPSET()
autocmd FileType java   call JAVASET()
autocmd FileType python call PYSET()



"""""""""""""""""""""""""" Plugins """"""""""""""""""""""""""""""""""

" Nerd Tree
map <C-E> :NERDTreeToggle<cr>
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1

" CtrlP
let g:ctrlp_working_path_mode = 'ra'

" indent_guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 0

" Vim move
let g:move_key_modifier = 'M'

"Vim-session
let g:session_autosave = 'yes'
let g:session_autoload = 'yes'

" Vim airline
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = '>'
let g:airline_branch_prefix = '⎇ '
let g:airline_section_y = ''
let g:airline#extensions#whitespace#enabled = 0

"Bufferline
let g:bufferline_echo = 0

""""""""""""""""""""""""""" Functions """""""""""""""""""""""""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
      return 'PASTE MODE  '
    en
    return ''
endfunction

" Python
function! PYSET()
  noremap py :!python<CR>
  noremap apy :%!python<CR>
endfunction

" C/C++:
function! CSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ gcc\ -O2\ -g\ -Wall\ -Wextra\ -o%.bin\ %\ -lm;fi;fi
  set cindent
  set textwidth=0
  set nowrap
endfunction

function! CPPSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ g++\ -std=gnu++0x\ -O2\ -g\ -Wall\ -Wextra\ -o%.bin\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
endfunction

" Java
function! JAVASET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
e