scriptencoding utf-8

set termguicolors
set number                                        " Enable line numbers
" Set StatusLine color before setting the rest of the config in case something
" breaks. That way, the status line will typically be visible.
highlight StatusLine ctermfg=52 guifg=#5f0000

set history=100
set mouse=""                                      " Disable mouse

set expandtab tabstop=2 shiftwidth=2              " Set indentation width and use spaces

" Fix for CVE-2019-12735
" See https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
" Seeing as modelines just litter files with editor-specific settings, they
" are mostly useless anyway.
set modelines=0

set nofoldenable                                  " Disable code collapsing

filetype plugin on
autocmd FileType python setlocal expandtab

autocmd FileType go setlocal tabstop=4 shiftwidth=4
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Make whitespace visible
set list
set listchars=tab:\»\ ,trail:·,extends:+,precedes:+

set showmatch                                     " Show matching brackets
set matchpairs+=<:>

" Use :XtermColorTable plugin to determine colors
" For attributes, see https://neovim.io/doc/user/syntax.html#attr-list
" For highlight groups, see https://neovim.io/doc/user/syntax.html#highlight-groups
highlight Title ctermfg=203 guifg=#ff5f5f
highlight Comment ctermfg=34 guifg=#00af00

" Constants
highlight Constant ctermfg=33 guifg=#0087ff
highlight String ctermfg=208 guifg=#ff8700
highlight Character ctermfg=196 guifg=#ff0000
highlight Number ctermfg=29 guifg=#00875f
highlight Boolean ctermfg=33 guifg=#0087ff
highlight Float ctermfg=31 guifg=#0087af

" Identifiers: Function
highlight Identifier ctermfg=226 guifg=#ffff00

" Statements: Conditional, Repeat, Label, Operator, Keyword, Exception
highlight Statement ctermfg=33 guifg=#0087ff
highlight Label cterm=bold ctermfg=69 ctermbg=52 gui=bold guifg=#5f87ff guibg=#5f0000
highlight Exception cterm=bold ctermfg=162 gui=bold guifg=#d70087

" PreProcs: Include, Define, Macro, PreCondit
highlight PreProc cterm=bold ctermfg=93 gui=bold guifg=#8700ff

" Types: StorageClass, Structure, Typedef
highlight Type ctermfg=125 guifg=#af005f

" Specials: SpecialChar, Tag, Delimiter, SpecialComment, Debug
highlight Special cterm=bold ctermfg=160 gui=bold guifg=#d70000

" TODO
highlight Todo cterm=bold ctermfg=237 ctermbg=220 gui=bold guifg=#3a3a3a guibg=#ffd700

" Search
highlight Search ctermfg=141 guifg=#af87ff ctermbg=58 guibg=#5f5f00
highlight CurSearch ctermfg=160 guifg=#d70000 ctermbg=9 guibg=#ff0000

" Matching brackets/parentheses
highlight MatchParen ctermfg=11 guifg=#ffff00 ctermbg=5 guibg=#800080

" Line numbers
highlight LineNr ctermfg=130 guifg=#af5f00

" Whitespace characters as determined by listchars
highlight Whitespace ctermfg=244 guifg=#808080
" EndOfBuffer and other characters that do not actually exist in the text
highlight NonText cterm=bold ctermfg=250 gui=bold guifg=#bcbcbc

" Visual mode selection
highlight Visual ctermbg=238 guibg=#444444

" Vim command menu
highlight Pmenu ctermbg=52 guibg=#5f0000
highlight PmenuSel ctermbg=124 guibg=#af0000

" Custom highlight groups (see /syntax)

" Namespaces
highlight Namespace ctermfg=160 guifg=#df0000

" Template brackets
highlight Template ctermfg=14 guifg=#00ffff

" Common operators
highlight Operators cterm=bold ctermfg=212 gui=bold guifg=#ff87d7

lua require('nvim-colorizer.lua.colorizer').setup()
