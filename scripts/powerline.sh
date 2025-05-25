# NerdFonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

# Powerline Status
if pip --version; then
    python -m pip install powerline-status
elif pip3 --version; then
    python3 -m pip install powerline-status
else
    echo "Neither `pip` nor `pip3` found"
    exit 1
fi
