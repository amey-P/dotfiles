PROGRAM_LIST="./programs.txt"
FAILED_INSTALLATION="./failed.txt"

# Installing all programs
if [ -z "$1" ];
then
	echo "Enter the installer command with appropriate flags."
	echo "Flags must enable the installer to install all files mentioned inside a text file."
	echo
	echo "apt-get install -y"
	echo "pacman -S"
	exit 1;
else
	while read p
	do
		$@ $p
		if [ $? != 0 ]
		then
			echo $p >> $FAILED_INSTALLATION
		fi
	done < $PROGRAM_LIST
fi

# Populating configs
ls -d */ | xargs stow

chsh -s $(which zsh)
