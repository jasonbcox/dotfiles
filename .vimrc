scriptencoding utf-8

set termguicolors
set number                                        " Enable line numbers
" Set StatusLine color before setting the rest of the config in case something
" breaks. That way, the status line will typically be visible.
highlight StatusLine ctermfg=52 guifg=DarkRed

set history=100
set mouse=""                                      " Disable mouse

set expandtab tabstop=2 shiftwidth=2              " Set indentation width and use spaces

" Fix for CVE-2019-12735
" See https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
" Seeing as modelines just litter files with editor-specific settings, they
" are mostly useless anyway.
set modelines=0

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

" Identifiers
highlight Identifier cterm=NONE ctermfg=226 guifg=#ffff00
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
highlight Search ctermfg=141 guifg=#af87ff ctermbg=58 guibg=#5f5f00
highlight CurSearch ctermfg=160 guifg=#d70000 ctermbg=9 guibg=#ff0000

" Matching brackets/parentheses
highlight MatchParen ctermfg=11 guifg=#ffff00 ctermbg=5 guibg=#800080

" Line numbers
highlight LineNr ctermfg=130 guifg=#af5f00

highlight NonText ctermfg=248 guifg=#a8a8a8

" Custom highlight groups

" Namespaces
highlight Namespace ctermfg=160 guifg=#df0000

" Template brackets
highlight Template ctermfg=14 guifg=#00ffff


syntax enable

if filereadable(glob("~/.vimrc.extras"))
  source ~/.vimrc.extras
endif

