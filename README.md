# Jason's dotfiles
------------------

## Setup

1. Copy .template.gituser to .gituser and modify the contents as necessary.

2. .profile_aliases is an optional file for containing any aliases that you want only on one machine.
(ex: alias db_dev="psql -h dev_database.work.com -p 1234 -U user pass)

3. 'ln -s .template.vimrc.override .vimrc.override' Create this symlink if you want to enforce spaces instead of tabs for various languages.

4. Create .gitligconfig and put any patterns that you want ignored from 'git lig'.  This file may be empty.

