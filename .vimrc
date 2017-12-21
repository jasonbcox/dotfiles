scriptencoding utf-8
set encoding=utf-8
set t_Co=256

set backupdir=~/.vim/backup
set directory=~/.vim/swap

set nocompatible                                  " Disable vi compatibility (use vim defaults instead)
set ruler
set number                                        " Enable line numbers
set laststatus=2
highlight StatusLine ctermfg=52 guifg=DarkRed
set history=100
set tw=0                                          " Don't wrap text

set autoindent                                    " Enable autoindenting
set expandtab tabstop=2 shiftwidth=2              " Set indentation width and use spaces

set backspace=indent,eol,start                    " Enable expected backspace behavior
set showmatch                                     " Show matching brackets
set incsearch                                     " Highlight as you type search queries

set wildmenu
set wildmode=longest,full                         " TAB-autocomplete shows the full list of options

" Pathogen - vim plugin system (see github.com/tpope/vim-pathogen
call pathogen#infect()

let g:vim_markdown_folding_disabled=1             " Disable code collapsing

filetype plugin on
autocmd FileType python setlocal expandtab

autocmd FileType go setlocal tabstop=4 shiftwidth=4
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Make whitespace visible
set listchars=tab:\»\ ,trail:·,extends:+,precedes:+

highlight Title ctermfg=203 guifg=#ff5f5f      " Red/IndianRed1
highlight Comment ctermfg=34 guifg=#00af00     " DarkGreen/Green3

" Constants
highlight Constant ctermfg=33 guifg=#0087ff    " DodgerBlue1
highlight String ctermfg=208 guifg=#ff8700     " DarkOrange
highlight Character ctermfg=196 guifg=#ff0000  " Red
highlight Number ctermfg=29 guifg=#00875f      " SpringGreen4/DarkCyan
highlight Boolean ctermfg=33 guifg=#0087ff     " DodgerBlue1
highlight Float ctermfg=31 guifg=#0087af       " DeepSkyBlue3

" Identifiers
highlight Identifier ctermfg=226 guifg=#ffff00 " Yellow/Yellow1
" Function

" Statements
highlight Statement ctermfg=33 guifg=#0087ff   " DodgerBlue1
" Conditional, Repeat, Label, Operator, Keyword, Exception

" PreProcs
highlight PreProc ctermfg=93 guifg=#8700ff     " Purple
" Include, Define, Macro, PreCondit

" Types
highlight Type ctermfg=125 guifg=#af005f       " DeepPink4
" StorageClass, Structure, Typedef

" Specials
highlight Special ctermfg=160 guifg=#d70000    " Red/Red3
" SpecialChar, Tag, Delimiter, SpecialComment, Debug

" Search
highlight Search ctermfg=160 guifg=#d70000 ctermbg=11 guibg=#ffff00     " Red/Red3 + Yellow/Yellow1

highlight NonText ctermfg=248 guifg=#a8a8a8

set list
syntax enable

if filereadable(glob("~/.vimrc.extras"))
  source ~/.vimrc.extras
endif

