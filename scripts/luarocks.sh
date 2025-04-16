
echo "Installing Luarocks..."

# Fetch the latest version from luarocks releases page
LUAROCKS_VERSION=$(curl -s https://luarocks.github.io/luarocks/releases/ | grep -o 'luarocks-[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.gz' | head -n 1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

if [ -z "$LUAROCKS_VERSION" ]; then
    echo "Failed to fetch latest Luarocks version, falling back to 3.11.1"
    LUAROCKS_VERSION="3.11.1"
fi

echo "Using Luarocks version: ${LUAROCKS_VERSION}"

LUAROCKS_URL="https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"

# Create a temporary directory for luarocks installation
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

# Download and extract luarocks
if ! curl -L $LUAROCKS_URL -o luarocks.tar.gz; then
    echo "Failed to download Luarocks" >> $FAILED_INSTALLATION
    exit 1
fi

tar xzf luarocks.tar.gz
cd "luarocks-${LUAROCKS_VERSION}"

# Configure and install
./configure
if ! make; then
    echo "Luarocks make failed" >> $FAILED_INSTALLATION
    exit 1
fi

if ! sudo make install; then
    echo "Luarocks installation failed" >> $FAILED_INSTALLATION
    exit 1
fi

# Clean up
cd ../..
rm -rf $TEMP_DIR

echo "Luarocks installation completed"
