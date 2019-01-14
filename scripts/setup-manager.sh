#!/usr/bin/env bash

TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='Ignition.conf'
CONFIG_FOLDER='/root/.Ignition'
BACKUP_FOLDER="$HOME/IgnitionBackups"
COIN_DAEMON='ignitiond'
COIN_PATH='/usr/local/bin/'
COIN_REPO='https://github.com/ignitioncoin/ignitioncoin.git'
#COIN_TGZ='http://www.mastermasternode.com/ignitioncoin/XXX.zip'
#COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_NAME='Ignition'
COIN_PORT=44144
RPC_PORT=44155
NODEIP=$(curl -s4 icanhazip.com)

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

purgeOldInstallation() {
    echo -e "${GREEN}Searching for, backing up any wallet, and removing old $COIN_NAME files and configurations${NC}"
    #kill wallet daemon
    systemctl stop $COIN_NAME.service > /dev/null 2>&1
    sudo killall $COIN_DAEMON > /dev/null 2>&1
    # TODO - Make Backup of Wallet.dat, Ignition.conf, and masternode.conf
    today="$( date +"%Y%m%d" )"
    #Create a backups folder inside users home directory
    test -d ~/IgnitionBackups && echo "Backups folder exists" || mkdir ~/IgnitionBackups
    iteration=0
    while test -d "$BACKUP_FOLDER/$today$suffix"; do
        (( ++iteration ))
        suffix="$( printf -- '-%02d' "$iteration" )"
    done
    foldername="$today$suffix"
    mkdir $BACKUP_FOLDER/$foldername
    mv $CONFIG_FOLDER/masternode.conf $BACKUP_FOLDER/$foldername
    mv $CONFIG_FOLDER/Ignition.conf $BACKUP_FOLDER/$foldername
    mv $CONFIG_FOLDER/wallet.dat $BACKUP_FOLDER/$foldername

    #remove old ufw port allow
    sudo ufw delete allow $COIN_PORT/tcp > /dev/null 2>&1
    #remove old files
    sudo rm -rf $CONFIG_FOLDER > /dev/null 2>&1
    sudo rm -rf /usr/local/bin/$COIN_DAEMON > /dev/null 2>&1
    sudo rm -rf /usr/bin/$COIN_DAEMON > /dev/null 2>&1
    sudo rm -rf /tmp/*
    echo -e "${GREEN}* Done${NONE}";
}