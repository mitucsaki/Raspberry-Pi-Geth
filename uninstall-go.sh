#!/bin/bash
set -e
    echo "Removing files and directories..."
    rm -rf $HOME/.go
	rm -rf $HOME/go
    sed -i '/# GoLang/d' "$HOME/.bashrc"
    sed -i '/export GOROOT/d' "$HOME/.bashrc"
    sed -i '/:$GOROOT/d' "$HOME/.bashrc"
    sed -i '/export GOPATH/d' "$HOME/.bashrc"
    sed -i '/:$GOPATH/d' "$HOME/.bashrc"
    echo "Done! Run 'source ~/.bashrc' to complete."
exit 0
