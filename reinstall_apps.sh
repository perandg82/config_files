#!/bin/bash

sudo apt update
sudo apt install zsh
chsh -s zsh perg
sudo snap refresh
sudo apt install eog ffmpeg
sudo snap install --classic nvim
sudo apt install ipython3
sudo apt install python3-pip
sudo apt install git
sudo apt install ninja-build
sudo apt install dfu-util device-tree-compiler ccache gperf gcc gcc-multilib g++-multilib libsdl2-dev
sudo apt install aptitude
sudo aptitude install golang
sudo aptitude install gnome-tweaks
sudo apt install libfuse2
sudo aptitude install gcc-aarch64-linux-gnu
sudo aptitude install picocom
sudo aptitude install audacity
sudo apt install curl
sudo aptitude install gnuplot
sudo apt install openssh-server
sudo snap install mqtt-explorer
sudo snap install slack
sudo snap install code
sudo snap install --classic cmake
sudo snap install spotify
pip3 install --user -U west

#if wayland
sudo aptitude install wl-clipboard
#elif [[ X11]]; then
sudo aptitude install xsel


echo "stuff that needs manual handling:"
echo "pip3 install -r --user ../zephyr/scripts/requirements.txt"
echo "pip3 install --user -r requirements.txt"
echo "pip3 install --user -U ecdsa"
echo "sudo apt install ./JLink_Linux_V782d_x86_64.deb"
echo "sudo apt install ./nrf-command-line-tools_10.19.0_amd64.deb"
