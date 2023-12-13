
syntax match Namespace /\([a-zA-Z0-9_]\+::\)*/
syntax match Template /<[a-zA-Z0-9_:<>]\+>/

" Logical operators
syntax match Operators /![^=]/me=e-1
syntax match Operators /||/
syntax match Operators /&&/
" Ternary operators (this also matches for-each and class definitions, but
" this is fine.
syntax match Operators / ? /
syntax match Operators / : /
