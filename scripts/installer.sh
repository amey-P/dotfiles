#! /bin/bash
read -p "Please enter your installer command: " cmd

PROGRAM_LIST="scripts/programs.txt"
FAILED_INSTALLATION="scripts/failed.log"
echo "" > $FAILED_INSTALLATION

# Installing all programs
# if [ -z "$1" ];
# then
# 	echo "Enter the installer command with appropriate flags."
# 	echo "Flags must enable the installer to install all files mentioned inside a text file."
# 	echo
# 	echo "apt-get install -y"
# 	echo "pacman -S"
# 	exit 1;
# else
while read p
do
	$cmd $p
	if [ $? != 0 ]
	then
		echo $p >> $FAILED_INSTALLATION
	fi
done < $PROGRAM_LIST

# Custom Installation
sh luarocks.sh

# Final setup for programs
chsh -s $(which zsh)
