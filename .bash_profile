
readonly TRUE="True"
readonly FALSE="False"

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

function parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

t_black=$(tput setaf 0)
t_red=$(tput setaf 1)
t_green=$(tput setaf 2)
t_yellow=$(tput setaf 3)
t_blue=$(tput setaf 4)
t_purple=$(tput setaf 5)
t_cyan=$(tput setaf 6)
t_white=$(tput setaf 7)
t_bold=$(tput bold)
t_reset=$(tput sgr0)
t_underline=$(tput sgr 0 1)


export PS1="\[$t_bold\]\[$t_yellow\]\u@\h\[$t_red\]\w\\[$t_green\]\$(parse_git_branch)\[$t_red\]$ \[$t_reset\]"

function isLinux() {
	if [ $(uname -s) = "Linux" ]; then
		echo $TRUE; return
	else
		echo $FALSE; return
	fi
}

function isMacOSX() {
	if [ $(uname -s) = "Darwin" ]; then
		echo $TRUE; return
	else
		echo $FALSE; return
	fi
}

function set_title { echo -ne "\033]0;"$*"\007"; }

if [ $(isLinux) = $TRUE ]; then
	alias ls='ls --color=auto'
fi

if [ $(isMacOSX) = $TRUE ]; then
	source /usr/local/bin/virtualenvwrapper.sh
	alias ls='ls -G'
fi

export TERM='xterm-256color'
[ -n "$TMUX" ] && export TERM=screen-256color

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.profile_aliases ] && source ~/.profile_aliases

