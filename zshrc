if [ "$TMUX" = "" ]; then tmux; fi

~/bin/config_git_status.sh
# The following lines were added by compinstall
zstyle :compinstall filename '/home/perg/.zshrc'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ”

fpath=(~/.zsh/completions $fpath)

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep

export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8

# Disable ctrl-s/q
if [[ -t 0 && $- = *i* ]]
then
    stty -ixon
fi

#setopt inc_append_history
#setopt share_history

######################
# ENV VARS AND ALIAS #
######################

# VIM stuff
EDITOR=nvim
alias nvim='nvim -p'
alias vim='nvim -p'
# Make reboot sudo only
alias reboot='echo "Your account is not allowed to run the reboot command without sudo"'
alias shutdown='echo "Your account is not allowed to run the shutdown command without sudo"'
# End of lines configured by zsh-newuser-install
export MYSSHCONFIG="/home/perg/.ssh/config"
export MYZSHRC="/home/perg/.zshrc"
export MYTMUXCONF="/home/perg/.tmux.conf"
alias ls='ls -lh --color=auto'
alias tmux='tmux -u'
# zephyr
#export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk

# Nordic
export NRF=nrf52840_pca10056
# nordic SDK build of embida fw for kit
export SDK_ROOT=~/spotics/embida/134-spotics-mini-mic/parts/93000-nRF-sdk/
alias find_sr="sudo nmap 10.0.0.0/24 -p 22 --open | grep -i murata -B 5"

#########################
# Stuff to do with PATH #
#########################
function test_path_and_add ()
{
	if [ $# = 1 ]; then
		if [[ -d $1 ]]; then
			if [[ ":$PATH:" != *":$1:"* ]]; then
				path+=("$1")
			fi
		fi
	fi
}

# Expand $PATH to include ARM embedded toolchain
export ARMGCC_DIR="/opt/gcc-arm-none-eabi"
export GNUARMEMB_TOOLCHAIN_PATH="/opt/gcc-arm-none-eabi"
test_path_and_add ${GNUARMEMB_TOOLCHAIN_PATH}
test_path_and_add ${ZEPHYR_SDK_INSTALL_DIR}
export RASPI_TOOLCHAIN_PATH="~/gitstuff/raspi_compile_tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64"
test_path_and_add ${RASPI_TOOLCHAIN_PATH}
export PROTOC_INSTALL_DIR="/opt/protoc/bin/"
test_path_and_add $PROTOC_INSTALL_DIR
export GNU_INSTALL_ROOT=$GNUARMEMB_TOOLCHAIN_PATH/bin/
# set PATH so it includes user's private bin if it exists
test_path_and_add "$HOME/bin"
test_path_and_add "$HOME/.local/bin"
test_path_and_add "/opt/eagle"
test_path_and_add "/usr/local/go/bin"

#############
# FUNCTIONS #
#############
function zephyr-addr2line () {
	if [ $# = 2 ]; then
		for i in $(ls $1/**/zephyr.elf | rev | cut -d" " -f1 | rev); do aarch64-linux-gnu-addr2line -e $i $2; done
	else
		echo "Two params needed, build folder and addr"
		echo "You gave $#"
	fi
}
function picocom () {
	/usr/bin/picocom -b 115200 -g /tmp/picocom-"$1:t".log "$1"
}

# function to speed up erase, prog etc of nrf kit
function nrf () {
	if [ "$1" = 'e' ]; then
		nrfjprog --eraseall
	elif [ "$1" = 'p' ]; then
		nrfjprog --program $2
	elif [ "$1" = 'r' ]; then
		nrfjprog --reset
	elif [ "$1" = 'a' ]; then
		nrfjprog --eraseall && nrfjprog --program $2 && nrfjprog --reset 
	elif [ "$1" = 's' ]; then
		nrfjprog -s $3 --eraseall && nrfjprog -s $3 --program $2 && nrfjprog -s $3 --reset 
	else
		echo "(e)rase, (r)eset, (p)rogram filename, or (a)ll filename"
	fi
}

function lilbitprog () {
	if [ ! -d build ]; then
		echo "No build folder available"
	else
		if [ "$1" = '52' ]; then
			nrfjprog -f nrf52 --program build/zephyr/zephyr.hex --chiperase --verify && nrfjprog -r
		elif [ "$1" = '91' ]; then
			nrfjprog -f nrf91 --program build/zephyr/merged.hex --chiperase --verify && nrfjprog -r
		else
			echo "Incorrect usage: lilbitprog [52|91]"
		fi
	fi
}

function osddone () {
	if (( $# == 0 )) then
		notify-send -t 10 -i /usr/share/pixmaps/faces/lightning.jpg "USPESIFISERT JOBB" "No e jobben din ferdig";
	else
		notify-send -t 10 -i /usr/share/pixmaps/faces/lightning.jpg $1 "No e jobben din ferdig";
	fi
}

function mkcd () {
	mkdir -p "$1"
	cd "$1"
}

function dr () {
	if (( $# == 0)) then
		echo "I need a target to run!"
	else
		if [ "$(docker container ls | grep $1)" = "" ]; then
			echo "Starting $1"
			docker start $1
		fi
		docker exec -ti $1 /bin/bash -l
	fi
}

function chsearch () {
	if (( $# == 0 ))
	then echo usage: chsearch pattern; fi
	grep -n $1 **/*.[ch]
}

r() {
	local f
	f=(~/.zsh/completions/*(.))
	echo $f:t
	unfunction $f:t 2> /dev/null
	autoload -U $f:t
}

########################
# SPECIAL KEY BINDINGS #
########################

bindkey -v
bindkey "^R" history-incremental-pattern-search-backward
bindkey '\e[1~'   beginning-of-line  # Linux console
bindkey '\e[H'    beginning-of-line  # xterm
bindkey '\eOH'    beginning-of-line  # gnome-terminal
bindkey '\e[2~'   overwrite-mode     # Linux console, xterm, gnome-terminal
bindkey '\e[3~'   delete-char        # Linux console, xterm, gnome-terminal
bindkey '\e[4~'   end-of-line        # Linux console
bindkey '\e[F'    end-of-line        # xterm
bindkey '\eOF'    end-of-line        # gnome-terminal

################
# SETUP PROMPT #
################

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M'
zstyle ':vcs_info:*' unstagedstr 'M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
	'%F{2}[%F{2}%b%F{2}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		hook_com[unstaged]+='%F{1}??%f'
	fi
}

precmd () { vcs_info }
#PROMPT='%(?..[%?] )%F{5}[%F{2}%m%F{5}|%F{2}%T%F{5}] ${vcs_info_msg_0_}%F{3}%#%f '
#PROMPT='%(?..[%?] )%F{189}[%F{189}%m%F{189}|%F{189}%T%F{189}] ${vcs_info_msg_0_}%F{213}%#%f '
PROMPT='%(?..[%?] )%F{189}[%F{189}%T%F{189}] ${vcs_info_msg_0_}%F{189}%#%f '

export RPROMPT='%F{213}%~'

