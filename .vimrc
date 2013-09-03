scriptencoding utf-8
set encoding=utf-8

set backupdir=~/.vim/backup
set directory=~/.vim/swap

set nocompatible				" Disable vi compatibility (use vim defaults instead)
set ruler
set history=100

set autoindent					" Enable autoindenting
set tabstop=4					" Set indentation width
set shiftwidth=4

set backspace=indent,eol,start	" Enable expected backspace behavior
set showmatch					" Show matching brackets
set incsearch					" Highlight as you type search queries

" Pathogen - vim plugin system (see github.com/tpope/vim-pathogen
call pathogen#infect()

filetype plugin on
autocmd FileType python set expandtab

" Make whitespace visible
set listchars=tab:\»\ ,trail:·,extends:+,precedes:+
highlight Comment ctermfg=DarkGreen guifg=#005f00
highlight String ctermfg=DarkYellow
highlight NonText ctermfg=248 guifg=#a8a8a8
highlight Special ctermfg=202 guifg=#ff5f00
set list
syntax enable

