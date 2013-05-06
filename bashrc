# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


[ -z "$PS1" ] && return

ulimit -c 0
shopt -s checkwinsize
shopt -s hostcomplete
shopt -s no_empty_cmd_completion
shopt -s xpg_echo
shopt -s execfail

PATH="/usr/local/bin:/usr/bin:/bin"
PATH="${PATH}:/usr/bin/X11:/usr/games"
PATH="${PATH}:~/bin"
PATH="${PATH}:~/.gem/ruby/1.8/bin"

export PATH="${PATH}:/sbin:/usr/sbin"
export HISTIGNORE=" *:&"

export PAGER=`which less`
export EDITOR=`which vim`
export GREP_OPTIONS='--color'
export G_BROKEN_FILENAMES=1
export PS_FORMAT="pid,euser,stat,bsdtime,vsz,sz,command"
export SVNTRUNK='svn+ssh://svn.lensbuddy.se/opt/subversion/main/trunk'
export SVNBRANCH='svn+ssh://svn.lensbuddy.se/opt/subversion/main/branches'
#export PYTHONPATH='/home/ulf/gitcopy/modules'
export PYTHONPATH='/storage/_favoptic/modules/live'
# Needed by ~/.vim/plugin/gnupg.vim
export GPG_TTY=`tty`

# Get colorization from the file .PS_COL 
PS_COL1=$(grep $(id -un):$(hostname -f) ~/.PS_COL | awk '{print $2}')
PS_COL2=$(grep $(id -un):$(hostname -f) ~/.PS_COL | awk '{print $3}')

# If no color is specified use thise defaults
if [ -z "$PS_COL1" -a $(id -un) = 'root' ]; then PS_COL1="1;41;37"; fi
if [ -z $PS_COL1 ]; then PS_COL1="1;47;30"; fi
if [ -z $PS_COL2 ]; then PS_COL2="1;40;37"; fi

function longprompt()
{
  local rc=$?
  export PS1="\[\e[${PS_COL1}m\]\u@\h\[\e[0m\]:\[\e[${PS_COL2}m\]\w($rc)\[\e[0m\]\\$ "
}
function shortprompt()
{
  local rc=$?
  export PS1="\[\e[${PS_COL1}m\]\u@\h\[\e[0m\]:\[\e[${PS_COL2}m\]($rc)\[\e[0m\]\\$ "
}

function screenprompt()
{
  local rc=$?
  export PS1="\[\e[0;${PS_COL1};1m\]\u@\h: $WINDOW :\w $rc \\$\[\e[0m\] "
}

function title()
{
  echo -n -e "\e]0;$*\007";
}

PROMPT_COMMAND=longprompt

if [ 'xterm' == $TERM ]; then title "/// ${HOSTNAME} ///"; fi

if [ 'screen' == $TERM ]; then PROMPT_COMMAND=screenprompt; fi

alias ls='ls --color=auto'
alias dir='ls --color=auto -alF'
alias ps='ps -elFH'
alias sp='PROMPT_COMMAND=shortprompt'
alias lp='PROMPT_COMMAND=longprompt'
alias sulb='sudo -u lensbuddy'
alias sufo='sudo -u favoptic'
alias kf="kill \`ps | grep firefox-bin | grep -v grep | awk '{print \$1}'\`"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
umask 0002

## Code fetched from http://markmail.org/message/yvgds7wr3pspw72a
svn() {
    case "$1" in co|checkout|export|st|stat|statussw|switch|up|update)
        svnargs1=""
        svnargs2="--ignore-externals"
        for i in $@; do
            if [ "--force-externals" == "$i" ]; then
                svnargs2=""
            else
                svnargs1="$svnargs1 $i"
            fi
        done
        if [ $svnargs2 = "--ignore-externals" ]; then
            echo "== Automatically adding '--ignore-externals'. Override with =="
            echo "== '--force-externals'. See: ~/.bashrc                      =="
        fi
        command svn $svnargs1 $svnargs2
        ;;
    *)
        command svn "$@"
        ;;
    esac
} 

if [ $(hostname -f) == "hovermo.favoptic.com" ]; then
    export GPGKEY=4249FA82
fi