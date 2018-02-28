#!/bin/bash
echo "Installing Dependencies..."
sudo apt-get -y install dphys-swapfile build-essential libgmp3-dev curl

echo "Cloning go-ethereum in /root..."
cd ~
git clone https://github.com/ethereum/go-ethereum
echo "Compiling geth..."
cd go-ethereum
make geth
