#!/usr/bin/bash
set -e

golang="1.10"
download="go$golang.linux-armv6l.tar.gz"

check {
  if [ "$EUID" -ne 0 ]; then
    error "Error, please run as root"
    exit 1
  fi
}

echo "Checking if golang is already installed..."
if [ -d "$HOME/.go" ] || [ -d "$HOME/go" ]; then
    echo "golang directories already exist. Exiting."
    exit 1
fi

echo "Downloading golang version $golang"
cd
wget https://dl.google.com/go/go$golang.linux-armv6l.tar.gz /golang.tar.gz

if [ $? -ne 0 ]; then
    echo "Download failed! Check script link and version."
    exit 1
fi

echo "Installing..."
tar -C "$HOME" -xzf /golang.tar.gz
mv "$HOME/go" "$HOME/.go"
touch "$HOME/.$bashrc"
{
    echo '# GoLang'
    echo 'export GOROOT=$HOME/.go'
    echo 'export PATH=$PATH:$GOROOT/bin'
    echo 'export GOPATH=$HOME/go'
    echo 'export PATH=$PATH:$GOPATH/bin'
} >> "$HOME/.$$bashrc"



mkdir -p $HOME/go/{src,pkg,bin}
echo -e "\nGolang $golang was installed.\nRe-initiate terminal to start variables"
rm -f golang.tar.gz

