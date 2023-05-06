syntax on  " enable syntax highlighting
filetype plugin indent on  " enable file tupe based indentation

set autoindent  " respect indentation when starting a new line
set expandtab  " expand tabs to spaces. Essential in Python
set tabstop=4  " number of spaces tab is counted for
set shiftwidth=4  " number of spaces to use for autoindent
set number  " show line numbers
set backspace=2 " fix backspace behaviour on most terminals

set directory=$HOME/.vim/swap//  " place all the swap files in a single directory
if !isdirectory("$HOME/.vim/swap")
    call mkdir("$HOME/.vim/swap", "p")
endif

colorscheme murphy  " change a colorscheme

" Set up persistent undo accross all files
set undofile
if !isdirectory("$HOME/.vim/undodir")
    call mkdir("$HOME/.vim/undodir", "p")
endif
set undodir="$HOME/.vim/undodir"
