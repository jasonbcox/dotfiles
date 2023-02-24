# Jason's dotfiles
------------------

## Setup

```
./setup.sh
```

Depending on desired environment, install additional useful packages using `./install-packages.sh`.
See `./install-packages.sh --help` for more info.

`./launch-tmux.sh` will be created from a template. Edit as you see fit for work on this machine.

## Platform-specific Setup

### OSX

Make sure the terminal properly sends the following:
```
^Up    : \033[1;5A (ESCAPE [1;5A)
^Down  : \033[1;5B (ESCAPE [1;5B)
^Left  : \033[1;5D (ESCAPE [1;5D)
^Right : \033[1;5C (ESCAPE [1;5C)
```

## vim Reminders

Move cursor to:
```
gg    Start of file
G     End of file

%     Matching brace or parentheses
```

Indentation:
```
>>    Indent line once
<<    De-indent line once
5>>   Indent line 5 times

>aB   Indent a block of code (cursor must be within the block)
>iB   Indent the inner lines of a block of code
<aB   De-indent a block
<iB   De-indent the inner lines of a block

]p    Paste text indented to be aligned with surroundings

.     Repeat last command
```
