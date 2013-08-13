
readonly TRUE="True"
readonly FALSE="False"

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
#export PS1="\u@\h\w$ "

export PS1="\[$(tput bold)\]\[$(tput setaf 3)\]\u@\h\[$(tput setaf 1)\]\w\[$(tput setaf 3)\]\\$ \[$(tput sgr0)\]"

function isMacOSX() {
	if [ $(uname -s) = "Darwin" ]; then
		echo $TRUE; return
	else
		echo $FALSE; return
	fi
}

function set_title { echo -ne "\033]0;"$*"\007"; }

if [ $(isMacOSX) = $TRUE ]; then
	source /usr/local/bin/virtualenvwrapper.sh
fi

