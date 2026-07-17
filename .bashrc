#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export COLORTERM=truecolor
if [[ -t 0 ]]; then
    stty -ixon 2>/dev/null
fi
PS1='[\u@\h \W]\$ '
[ -f ~/export-esp.sh ] && . ~/export-esp.sh
