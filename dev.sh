#!/bin/bash
tmux set remain-on-exit on
tmux new-session -d 'vim'
tmux split-window -h 'bin/rails server'
tmux resize-pane -x 50
tmux attach
