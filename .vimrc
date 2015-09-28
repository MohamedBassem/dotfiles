
""""""""""""""""""""""" Vundle Configuration """"""""""""""""""""""""""""""""""""

syntax on

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/vim-tomorrow-theme'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'gabrielelana/vim-markdown'
"Plugin 'mbbill/undotree'
"Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdcommenter'
"Plugin 'matze/vim-move'
"Plugin 'ervandew/supertab'
Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-session'
Plugin 'bling/vim-airline'
"Plugin 'tpope/vim-fugitive'
"Plugin 'tpope/vim-rails'
"Plugin 'bling/vim-bufferline'
Plugin 'gcmt/wildfire.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'mutewinter/nginx.vim'
"Plugin 'mhinz/vim-startify'
"Plugin 'StanAngeloff/php.vim'
Plugin 'bkad/CamelCaseMotion'
Plugin 'kana/vim-textobj-user'
"Plugin 'nelstrom/vim-textobj-rubyblock'
"Plugin 'Rip-Rip/clang_complete'
Plugin 'Valloric/YouCompleteMe'
"Plugin 'kchmck/vim-coffee-script'
"Plugin 'mintplant/vim-literate-coffeescript'
Plugin 'ekalinin/Dockerfile.vim'
"Plugin 'terryma/vim-multiple-cursors'
Plugin 'benmills/vimux'
"Plugin 'xuhdev/SingleCompile'
"Plugin 'vim-scripts/a.vim'
"Plugin 'xolox/vim-easytags'
Plugin 'craigemery/vim-autotag'
"Plugin 'xuhdev/vim-latex-live-preview'
"Plugin 'jcf/vim-latex'
Plugin 'fatih/vim-go'
"Plugin 'godlygeek/tabular'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'christoomey/vim-tmux-navigator'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

""""""""""""""""""""""""""""""""""  General  """"""""""""""""""""""""""""""""""""""""

runtime macros/matchit.vim

set mouse=a

set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

set pastetoggle=<F2>           " pastetoggle (sane indentation on pastes)

set nu    " Show line numbers

" Show trailing white spaces as dots
set list listchars=tab:»~,trail:~

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" Tabs sizes
set shiftwidth=2                " Use indents of 2 spaces
set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent

set ai "Auto indent
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set si "Smart indent
set nowrap "Don't Wrap lines
set noswapfile

set history=700

" while typing a command, show it in the bottom right corner
set showcmd

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

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

" Don't move cursor to beginning to line
set nosol

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

" Black hole deletion/change (persist yanked lines in non-visual mode)
nnoremap d "_d
nnoremap dd "_dd
nnoremap D "_D
nnoremap c "_c
nnoremap C "_C
nnoremap x "_x

" Stop the stupid windows
map q: :q

"""""""""""""""""""""""""" Colors """""""""""""""""""""""""""""""""""""""""""""
set background=dark
color Tomorrow-Night

let g:indent_guides_auto_colors = 0 
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=black ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey ctermbg=darkgrey

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine

"""""""""""""""""""""""""" Moving Around """""""""""""""""""""""""""""""""""""""""


" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Fast scrolling
noremap <Right> 20zl
noremap <Left> 20zh
noremap <Up> 20<C-y>
noremap <Down> 20<C-e>

" Disable highlight
nnoremap <leader><CR> :noh<cr>

" Disable latex conflict with <C-j>
map <silent>$# <Plug>IMAP_JumpForward

" move to end of pasted text, to ease multiple pastes
vnoremap y y`]
vnoremap p p`]
nnoremap p p`]

" Some helpers to edit mode
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%

" Map the compile and run custom function
map <leader>r :call MakeAndRun(0)<cr>
map <leader>rf :call MakeAndRun(1)<cr>

set hidden
map tl :MBEbn<CR>
map th  :MBEbp<CR>
cabbrev bd MBEbd
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
let NERDTreeChDirMode=2

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|aux|lof|bbl|blg|log|toc|out)$',
  \ 'link': '',
  \ }

" Vim airline
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = '>'
let g:airline_symbols = {}
let g:airline_symbols.branch = '⎇ '
let g:airline_section_y = ''
let g:airline#extensions#whitespace#enabled = 0

"MiniBuffExpl
let g:miniBufExplBRSplit = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplBuffersNeeded = 0
let g:miniBufExplCycleArround = 1

"You compelete Me
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
set completeopt-=preview

" LaTeX-Suite
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_GotoError = 0
let g:Tex_AutoFolding = 0
let g:Tex_Folding = 0

" Syntastic
let g:syntastic_cpp_compiler_options = ' -std=c++11'

"vim-go
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

"Utlisnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-a>h :TmuxNavigateLeft<cr>
nnoremap <silent> <c-a>j :TmuxNavigateDown<cr>
nnoremap <silent> <c-a>k :TmuxNavigateUp<cr>
nnoremap <silent> <c-a>l :TmuxNavigateRight<cr>


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
  noremap ,py :!python<CR>
  noremap ,apy :%!python<CR>
  set shiftwidth=4
  set tabstop=4
  set softtabstop=4
endfunction

" C/C++:
function! CSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ gcc\ -O2\ -g\ -Wall\ -o%.bin\ %\ -lm;fi;fi
  set errorformat^=%-G%f:%l:\ warning:%m
  set cindent
  set textwidth=0
  set nowrap
  command! Execute call VimuxRunCommand(expand('%:p') . '.bin') | call system("tmux select-"._VimuxRunnerType()." -t ".g:VimuxRunnerIndex)
endfunction

function! CPPSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ g++\ -std=gnu++0x\ -O2\ -g\ -Wall\ -o%.bin\ %;fi;fi
  set errorformat^=%-G%f:%l:\ warning:%m
  set cindent
  set textwidth=0
  set nowrap
  command! Execute call VimuxRunCommand(expand('%:p') . '.bin') | call system("tmux select-"._VimuxRunnerType()." -t ".g:VimuxRunnerIndex)
endfunction

" Java
function! JAVASET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
endfunction

function! MakeAndRun(forceRun)
  :make!
  if len(getqflist()) == 0 || a:forceRun == 1
    :Execute
  endif
endfunction

function! FixTabs()
  :set tabstop=2 shiftwidth=2 expandtab
  :retab
endfunction
