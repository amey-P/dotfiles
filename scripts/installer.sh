#! /bin/bash
read -p "Please enter your installer command: " cmd

LOG="scripts/installation.log"

echo "" > $LOG

sudo $cmd -y $(cat scripts/programs.txt) 2>&1 | tee $LOG

# Custom Installation
sh luarocks.sh

# Snap Installation
sudo snap install nvim --classic
sudo snap install yazi --classic

