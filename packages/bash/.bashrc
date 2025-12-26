# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# The AWESOME vi-mode
#set -o vi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

PROMPT_COMMAND='history -a'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=40000
export HISTIGNORE='ls:cd:pwd:clear:exit:history'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Generate a bash completion script for pandoc
eval "$(pandoc --bash-completion)"

xhost + > /dev/null 2> /dev/null
if [ "$(uname -s)" == "Darwin" ]; then
  source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
fi
export PS1="\[\033[01;35m\]\`echo \$(__git_ps1)\`\[\033[00m\]$PS1"
export PS1="\[\033[01;33m\][\`printf %3d \$?\`]\[\033[00m\] $PS1"

source ~/.bash_aliases

## BashHistory options
## No duplicates in the history
export HISTCONTROL=ignoredups
export HISTSIZE=100000
## Timestamp history
export HISTTIMEFORMAT="%b %d %a %T "
## Don't Overwrite. Append to bash history.
shopt -s histappend
export PYTHONSTARTUP=~/.pythonrc

function finf() {
  if [ $# == 1 ]; then
    echo find . -type f -exec grep -EHni --color=auto \"$1\" {} \;
    find . -type f -exec grep -EHni --color=auto "$1" {} \;
  elif [ $# == 2 ]; then
    helper="-iname"
  else
    helper=""
  fi

  key=$1
  shift
  echo find $helper "$@" -type f -exec grep -EHni --color=auto "$key" {} \;
  find $helper "$@" -type f -exec grep -EHni --color=auto "$key" {} \;
}

########## Proxy server #############
function set_proxy() {
    export http_proxy="http://194.138.0.25:9400"
    export https_proxy="https://194.138.0.25:9400"
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$https_proxy
    export ftp_proxy=$http_proxy
    export rsync_proxy=$http_proxy
    export no_proxy="localhost,127.0.0.1,localaddress,.siemens.com,.siemens.de,.siemens.io"
    sudo cp ~/.docker/http-proxy.conf /etc/systemd/system/docker.service.d \
      && sudo systemctl daemon-reload \
      && sudo systemctl restart docker
}
function unset_proxy() {
    unset http_proxy
    unset https_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset ftp_proxy
    unset rsync_proxy
    sudo rm /etc/systemd/system/docker.service.d/http-proxy.conf \
      && sudo systemctl daemon-reload \
      && sudo systemctl restart docker
}

#export -f unset_proxy
function add_ssh_keys() {
  count=$(ssh-add -L | grep -c /home/psimit/.ssh/id_rsa)
  if [ $count -eq 0 ]; then
    ssh-add
  fi
}
add_ssh_keys

if [ "$(uname -s)" == "Linux" ]; then
  source /opt/ros/noetic/setup.bash
fi

ADDR_MAGIC_MOUSE="BC:D0:74:CE:23:50"
ADDR_KBD="E9:24:11:B2:36:DB"

function workstation_mode() {
  if [ "$1" == "4K" ]; then
    xrandr --output eDP-1 --mode 1600x1024
    xrandr --output HDMI-1 --mode 3840x2160 --scale 0.75x0.75 --right-of eDP-1
  else
    xrandr --output eDP-1 --mode 1600x1024
    xrandr --output HDMI-1 --mode 2560x1440 --scale 1x1 --right-of eDP-1
  fi
  bluetoothctl connect ${ADDR_MAGIC_MOUSE}
  sleep 1
  upower -i /org/freedesktop/UPower/devices/mouse_hid_bcod0o74oceo23o50_battery
  mouse_id=$(xinput | grep "Magic Mouse" | sed -nE 's/.*id=([0-9]+).*/\1/p')
  xinput set-prop ${mouse_id} "libinput Natural Scrolling Enabled" 1
  xinput set-prop ${mouse_id} "libinput Accel Speed" -0.5
  xinput set-button-map ${mouse_id} 1 1
  echo -1 | sudo tee /sys/module/usbcore/parameters/autosuspend
}

function laptop_mode() {
  xrandr --output HDMI-1 --off
  xrandr --output eDP-1 --mode 1920x1200
  echo 2 | sudo tee /sys/module/usbcore/parameters/autosuspend
}

cursor() {
  # Run the cursor command and suppress background process output completely
  (nohup /home/psimit/third-party/Cursor-1.2.1-x86_64.AppImage "$@" >/dev/null 2>&1 &)
}

export PATH=$PATH:/home/psimit/third-party/mips-linux-gnu-ingenic-gcc7.2.0-glibc2.29-fp64/bin
export BUILDKIT_COLORS=run=green:warning=yellow:error=red:cancel=cyan

# Start tmux automatically
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi