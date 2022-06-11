#!/bin/bash

sudo pacman -Sy tmux playerctl

ln -bs "$PWD/.tmux.conf" ~/.tmux.conf
ln -bs "$PWD/.tmux" ~/.tmux
