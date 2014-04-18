
readonly TRUE="True"
readonly FALSE="False"

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
#export PS1="\u@\h\w$ "

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export XIM_PROGRAM=/usr/bin/ibus-daemon
ibus-daemon -x -d

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

[ -f ~/.profile_aliases ] && source ~/.profile_aliases

