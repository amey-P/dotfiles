sudo snap install nvim --classic

# Rocks Installer
nvim -u NORC -c "source https://raw.githubusercontent.com/nvim-neorocks/rocks.nvim/master/installer.lua"
nvim "+Rocks sync"
