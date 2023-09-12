#!/bin/bash

SCRIPT_FOLDER=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Config files are located in $SCRIPT_FOLDER"

[ ! -d ~/bin ] && mkdir ~/bin

STATUSFILE=~/bin/config_git_status.sh
echo "#!/bin/bash" > $STATUSFILE
echo "" >> $STATUSFILE
echo "cd $SCRIPT_FOLDER" >> $STATUSFILE
echo "git status -s" >> $STATUSFILE
echo "" >> $STATUSFILE
chmod +x ~/bin/config_git_status.sh

rm -vrf ~/.tmux.conf
rm -vrf ~/.zshrc 
rm -vrf ~/.config/nvim
ln -vsf $SCRIPT_FOLDER/tmux.conf ~/.tmux.conf
ln -vsf $SCRIPT_FOLDER/zshrc ~/.zshrc
ln -vsf $SCRIPT_FOLDER/nvim-config ~/.config/nvim

echo "Done!"
