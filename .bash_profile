
readonly TRUE="True"
readonly FALSE="False"

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
#export PS1="\u@\h\w$ "

export PS1="\[$(tput bold)\]\[$(tput setaf 3)\]\u@\h\[$(tput setaf 1)\]\w\[$(tput setaf 3)\]\\$ \[$(tput sgr0)\]"

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

