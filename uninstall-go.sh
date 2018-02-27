#!/usr/bin/bash
set -e

check {
  if [ "$EUID" -ne 0 ]; then
    error "Error, please run as root"
    exit 1
  fi
}
    rm -rf "$HOME/.go/"
    sed -i '/# GoLang/d' "$HOME/.$bashrc"
    sed -i '/export GOROOT/d' "$HOME/.$bashrc"
    sed -i '/:$GOROOT/d' "$HOME/.$bashrc"
    sed -i '/export GOPATH/d' "$HOME/.$bashrc"
    sed -i '/:$GOPATH/d' "$HOME/.$bashrc"
    echo "golang removed"
exit 0

