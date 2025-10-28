#if [ "$TMUX" = "" ]; then tmux; fi

GIT_STATUS_FILE=${HOME}/bin/config_git_status.sh
if [[ -x $GIT_STATUS_FILE ]]; then
	$GIT_STATUS_FILE
else
	echo "Not executing ${GIT_STATUS_FILE}"
fi
# The following lines were added by compinstall
zstyle :compinstall filename '${HOME}/.zshrc'
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

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

#setopt inc_append_history
#setopt share_history

######################
# ENV VARS AND ALIAS #
######################

# VIM stuff
EDITOR=nvim
alias nvim='nvim -p'
alias vim='nvim'
alias less='less --raw'
# Make reboot sudo only
alias reboot='echo "Your account is not allowed to run the reboot command without sudo"'
alias shutdown='echo "Your account is not allowed to run the shutdown command without sudo"'
# End of lines configured by zsh-newuser-install
export MYSSHCONFIG="${HOME}/.ssh/config"
export MYZSHRC="${HOME}/.zshrc"
export MYTMUXCONF="${HOME}/.tmux.conf"
export LOCALZSHRC="${HOME}/.localzshrc"
alias ls='ls -lh --color=auto'
alias tmux='tmux -u'
alias ta='tmux attach -t'
alias tn='tmux new-session -s'
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
test_path_and_add ${GNUARMEMB_TOOLCHAIN_PATH}/bin
test_path_and_add ${ZEPHYR_SDK_INSTALL_DIR}/aarch64-zephyr-elf/bin
export AARCH64_TOOLCHAIN="aarch64-zephyr-elf"
export RASPI_TOOLCHAIN_PATH="~/gitstuff/raspi_compile_tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64"
test_path_and_add ${RASPI_TOOLCHAIN_PATH}/bin
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
function zephyr-dts-lookup () {
	if [ $# = 2 ]; then
		build=$1
		dts_nr=$2
	elif [ $# = 1 ]; then
		build="build"
		dts_nr=$1
	else
		echo "Two params needed, build folder and dts ord number"
		echo "Build folder can be omitted if it is 'build'"
		return
	fi

	ls ${build}/zephyr/**/devicetree_generated.h
	if [ ! $? = 0 ]; then
		echo "Cannot find dts file:"
		return
	fi
	dtsfile=$(ls ${build}/zephyr/**/devicetree_generated.h | rev | cut -d" " -f 1 | rev)
	echo $dtsfile
	header_end=$(grep -n "*/" $dtsfile | head -n1 | cut -d ":" -f1)
	echo "Grepping first $header_end lines"
	head -n $header_end $dtsfile | grep $dts_nr
}

function zephyr-addr2line () {
	if [ $# = 2 ]; then
		build=$1
		addr=$2
	elif [ $# = 1 ]; then
		build="build"
		addr=$1
	else
		echo "Two params needed, build folder and addr in hex"
		echo "Build folder can be omitted if it is 'build'"
		return
	fi
	for i in $(ls ${build}/**/zephyr.elf | rev | cut -d" " -f1 | rev); do ${AARCH64_TOOLCHAIN}-addr2line -e $i $addr; done
}

function zephyr-config-lookup () {
	if [ $# = 2 ]; then
		build=$1
		config=$2
	elif [ $# = 1 ]; then
		build="build"
		config=$1
	else
		echo "Two params needed, build folder and config option (case insensitive)"
		echo "Build folder can be omitted if it is 'build'"
		return
	fi

	configfile=${build}/zephyr/.config
	if [ ! -f $configfile ]; then
		echo "File $configfile is not available"
		return
	fi
	grep -inr $config $configfile
}

function tio () {
	t=$(which tio)
	if [[ ! -x ${t} ]]
	then
		echo "Tio is not installed!"
	else
		${t} --log --log-file /tmp/tio-"$1:t".log  --log-append "$1"
	fi
}

function picocom () {
	echo "You want to use tio"
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
	sign52=683850517
	sign91=602005433
	if [ ! -d build ]; then
		echo "No build folder available"
	else
		if [ "$1" = '52' ]; then
			nrfjprog -f nrf52 -s ${sign52} --program build/zephyr/zephyr.hex --chiperase --verify -r
		elif [ "$1" = '91' ]; then
			nrfjprog -f nrf91 -s ${sign91} --program build/zephyr/merged.hex --chiperase --verify -r
		else
			echo "Incorrect usage: lilbitprog [52|91]"
		fi
	fi
}

function rttlog () {
	if [ ! -d build ]; then
		echo "No build folder available"
		return
	fi
	RTTAddress=$(cat build/zephyr/zephyr.map | grep '0x.* *_SEGGER_RTT' | sed 's/_SEGGER_RTT//;s/ //g') ;
	JLinkRTTLogger -Device CORTEX-M4 -If SWD -Speed 4000 -RTTAddress $${RTTAddress} -RTTChannel 0 /tmp/rtt_log
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
	'%F{2}[%F{2}%b%F{2}] %F{2}%c%F{213}%u%m%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-submodule-check
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		hook_com[unstaged]+='%F{213}??%f'
	fi
}
+vi-git-submodule-check() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
	   git submodule status --recursive | grep '^-' &> /dev/null; then
		# Add a visual warning (e.g., a lightning bolt or 'S!') in a distinct color
		hook_com[misc]+='%F{3}S%f'
	fi
}

precmd () { vcs_info }
#PROMPT='%(?..[%?] )%F{5}[%F{2}%m%F{5}|%F{2}%T%F{5}] ${vcs_info_msg_0_}%F{3}%#%f '
#PROMPT='%(?..[%?] )%F{189}[%F{189}%m%F{189}|%F{189}%T%F{189}] ${vcs_info_msg_0_}%F{213}%#%f '
if [ "$DISTROBOX_ENTER_PATH" = "" ];
then  
	PROMPT='%(?..[%?] )%F{189}[%F{189}%T%F{189}] ${vcs_info_msg_0_}%F{189}%#%f '
	export RPROMPT='%F{2}%~'
else
	PROMPT='%(?..[%?] )%F{2}[%F{2}%m] ${vcs_info_msg_0_}%F{2}%#%f '
	export RPROMPT='%F{2}%~'
fi

[ -f ${LOCALZSHRC} ] && source ${LOCALZSHRC}
