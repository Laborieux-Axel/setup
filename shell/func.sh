acti() { source ~/workspace/venvs/$1/bin/activate ;}
psg() { ps aux | grep $1 ;}
hig() { cat ~/.bash_history | grep $1 ;}
tms() { tmux new-session -s $1 ;}
tma() { tmux attach -t $1 ;}
tmk() { tmux kill-session -t $1 ;}
