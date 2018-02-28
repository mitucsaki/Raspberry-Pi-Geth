#!/bin/bash
set -e

GO="1.9.3"
echo "Checking for existing versions..."
if [ -d "$HOME/.go" ] || [ -d "$HOME/go" ]; then
    echo "Go directories already exist."
    exit 1
fi

echo "Downloading Go 1.9.3..."
wget https://dl.google.com/go/go$GO.linux-armv6l.tar.gz -O $HOME/go.tar.gz

if [ $? -ne 0 ]; then
    echo "Download failed!"
    exit 1
fi

echo "Creating Directories..."
tar -C "$HOME" -xzf $HOME/go.tar.gz
mv "$HOME/go" "$HOME/.go"
touch "$HOME/.bashrc"
{
    echo '# GoLang'
    echo 'export GOROOT=$HOME/.go'
    echo 'export PATH=$PATH:$GOROOT/bin'
    echo 'export GOPATH=$HOME/go'
    echo 'export PATH=$PATH:$GOPATH/bin'
} >> "$HOME/.bashrc"

mkdir -p $HOME/go/{src,pkg,bin}
echo "Removing downloaded tar..."
rm -f $HOME/go.tar.gz
echo "Done! Run 'source ~/.bashrc' to complete!"
