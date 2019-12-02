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

# Start with /home/ulf/bin to make my own definitions (in bin/) take precedence
# over those defined by the system.
PATH="/home/ulf/bin"  # Do not rely on ~ (see: http://stackoverflow.com/q/32199176/42580)
PATH="${PATH}:/home/ulf/.gem/ruby/1.8/bin"
PATH="${PATH}:/usr/local/sbin:/usr/local/bin"
PATH="${PATH}:/usr/sbin:/usr/bin"
PATH="${PATH}:/sbin:/bin"
PATH="${PATH}:/usr/games:/usr/local/games"
PATH="${PATH}:/usr/bin/X11"
PATH="${PATH}:/usr/NX/bin"
export PATH="${PATH}"

export HISTIGNORE=" *:&"
# HISTTIMEFORMAT seems like a nice thing:
#   http://www.thegeekstuff.com/2008/08/15-examples-to-master-linux-command-line-history/
export HISTTIMEFORMAT='%F %T: '

export PAGER=`which less`
export EDITOR=`which vim`
export G_BROKEN_FILENAMES=1
export PS_FORMAT="pid,euser,stat,bsdtime,vsz,sz,command"
export SVNTRUNK='svn+ssh://svn.lensbuddy.se/opt/subversion/main/trunk'
export SVNBRANCH='svn+ssh://svn.lensbuddy.se/opt/subversion/main/branches'
#export PYTHONPATH='/home/ulf/gitcopy/modules'
export PYTHONPATH='/storage/_favoptic/modules'
# Needed by ~/.vim/plugin/gnupg.vim
export GPG_TTY=`tty`
# I run no postgres locally by have portforvard setup in virtualbox so I can
# connect to localhost and automagically end up on the db-machine. But to
# avoid having to specify localhot to psql PGHOST is defined.
export PGHOST=localhost


# Get colorization from the file .PS_COL
PS_COL1=$(~/.PS_COL -c1)
PS_COL2=$(~/.PS_COL -c2)

function venv_info()
{
    # Add virtualenv info to prompt if its activated. See:
    #   http://stackoverflow.com/questions/14987013/
    if [ "$VIRTUAL_ENV" != "" ]; then
        echo "\[\e[1;41;30m\](`basename \"$VIRTUAL_ENV\"`)\[\e[0m\]"
    fi
}

# If you in some environments/cases whant to prepend your prompt with
# something, then set PS_PREFIX like so:
#   $ export PS_PREFIX=SOME_MSG
ping -c1 -w1 192.168.100.35 > /dev/null 2>&1
[ $? -eq 0 ] && export PS_PREFIX=TEST
function longprompt()
{
  local rc=$?
  if [ -n "$PS_PREFIX" ]; then
    local PRE="\[\e[1;41;32m\](${PS_PREFIX})\[\e[0m\]"
  fi
  export PS1="${PRE}\[\e[${PS_COL1}m\]\u@\h\[\e[0m\]:\[\e[${PS_COL2}m\]\w($rc)$(venv_info)\[\e[0m\]\\$ "
}
function shortprompt()
{
  local rc=$?
  if [ -n "$PS_PREFIX" ]; then
    local PRE="\[\e[1;41;32m\](*)\[\e[0m\]"
  fi
  export PS1="${PRE}\[\e[${PS_COL1}m\]\u@\h\[\e[0m\]:\[\e[${PS_COL2}m\]($rc)$(venv_info)\[\e[0m\]\\$ "
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
alias kf="kill \`ps | grep firefox-bin | grep -v grep | awk '{print \$1}'\`"
alias gqview='echo "Run geegie instead"'
alias grep='grep --color'
# Help me add an agent when I log in from home or elsewere.
alias ssh-add-agent='eval `ssh-agent`;ssh-add'
alias sshaa=ssh-add-agent
# Shorthand for parallel-ssh
alias pssh='parallel-ssh -i -t 10 -h ~/allhosts.txt'

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
export ARDUINO_DIR=/home/ulf/arduino_install/latest
export ARDMK_DIR=/home/ulf/arduino_install/Arduino-Makefile
