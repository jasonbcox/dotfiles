scriptencoding utf-8
set encoding=utf-8
set t_Co=256
set term=screen-256color

set backupdir=~/.vim/backup
set directory=~/.vim/swap

set nocompatible                                  " Disable vi compatibility (use vim defaults instead)
set ruler
set number                                        " Enable line numbers
set laststatus=2
highlight StatusLine ctermfg=52 guifg=DarkRed
set history=100
set tw=0                                          " Don't wrap text
set mouse=""                                      " Disable mouse over SSH

set autoindent                                    " Enable autoindenting
set expandtab tabstop=2 shiftwidth=2              " Set indentation width and use spaces

set backspace=indent,eol,start                    " Enable expected backspace behavior
set showmatch                                     " Show matching brackets
set incsearch                                     " Highlight as you type search queries

set wildmenu
set wildmode=longest,full                         " TAB-autocomplete shows the full list of options

" Fix for CVE-2019-12735
" See https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
" Seeing as modelines just litter files with editor-specific settings, they
" are mostly useless anyway.
set modelines=0
set nomodeline

" When writing encrypted files (:X), use a strong encryption method
" If additional security is desired, consider setting the following in
" encrypted vim sessions to disable clear text being written to disk:
" set viminfo= | set nobackup | set nowritebackup
set cryptmethod=blowfish2

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

" Use :XtermColorTable plugin to determine colors
highlight Title ctermfg=203 guifg=#ff5f5f
highlight Comment ctermfg=34 guifg=#00af00

" Constants
highlight Constant ctermfg=33 guifg=#0087ff
highlight String ctermfg=208 guifg=#ff8700
highlight Character ctermfg=196 guifg=#ff0000
highlight Number ctermfg=29 guifg=#00875f
highlight Boolean ctermfg=33 guifg=#0087ff
highlight Float ctermfg=31 guifg=#0087af

" Identifiers
highlight Identifier ctermfg=226 guifg=#ffff00
" Function

" Statements
highlight Statement ctermfg=33 guifg=#0087ff
" Conditional, Repeat, Label, Operator, Keyword, Exception

" PreProcs
highlight PreProc ctermfg=93 guifg=#8700ff
" Include, Define, Macro, PreCondit

" Types
highlight Type ctermfg=125 guifg=#af005f
" StorageClass, Structure, Typedef

" Specials
highlight Special ctermfg=160 guifg=#d70000
" SpecialChar, Tag, Delimiter, SpecialComment, Debug

" Search
highlight Search ctermfg=160 guifg=#d70000 ctermbg=11 guibg=#ffff00

" Matching brackets/parentheses
highlight MatchParen ctermfg=220 guifg=#ffdf00 ctermbg=5 guibg=#ff00ff

highlight NonText ctermfg=248 guifg=#a8a8a8

set list
syntax enable

if filereadable(glob("~/.vimrc.extras"))
  source ~/.vimrc.extras
endif

