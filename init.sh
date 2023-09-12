#!/bin/bash

SCRIPT_FOLDER=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Config files are located in $SCRIPT_FOLDER"

rm -vrf ~/.tmux.conf
rm -vrf ~/.zshrc 
rm -vrf ~/.config/nvim
ln -vsf $SCRIPT_FOLDER/tmux.conf ~/.tmux.conf
ln -vsf $SCRIPT_FOLDER/zshrc ~/.zshrc
ln -vsf $SCRIPT_FOLDER/nvim-config ~/.config/nvim

echo "Done!"
