alias ls="ls -lah --color=auto"
alias sl=ls
alias sb="source ~/.bashrc"
alias vb="vim ~/.bashrc"
alias nv="watch -n 1 nvidia-smi"
alias vpi="vim ~/.pi/agent/models.json"
alias voc="vim ~/.config/opencode/opencode.json"
alias nvv='watch "nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,nounits && nvidia-smi --query-compute-apps=pid --format=csv"'
alias glo="git log --oneline"

alias mv="mv -i"           # -i prompts before overwrite
alias mkdir="mkdir -p"     # -p make parent dirs as needed
alias df="df -h"           # -h prints human readable format

alias gs="git status"
alias gc="git commit"
alias v="vim"

alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
