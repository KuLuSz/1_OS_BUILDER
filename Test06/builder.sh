#!/bin/bash

if [ ! -t 0 ];then
$TERM -e $0 &
exit
fi

BN="Puppy Builder CE"

#usage: kernel:HUGEKERNELURL (where found huge kernel tar.bz2 packages)
HUGE_KERNEL="
kernel:https://distro.ibiblio.org/puppylinux/huge_kernels/
"

#usage: DISTRONAME:REPOURL (where found dists and pool folders)
# USE ONLY DEBIAN SPECIFIC DISTRO REPOSITORY!
REPOS="
ubuntu:http://us.archive.ubuntu.com/ubuntu/
debian:http://ftp.hu.debian.org/debian/
devuan:http://deb.devuan.org/devuan/
"

BD="${0%/*}" 						# base folder
TMP="$BD/tmp"						# temp folder
SCRIPT_DIR="$BD/scripts"			# script folder
RDBM="$BD/repo_db_mod"				# repo database modifications dir
RD="$TMP/repo"						# repo dir
RF="$TMP/repository"				# converted repository file
PFL="$TMP/pkg_list"					# package file list
PL="$TMP/chooser_pkg_list"			# selected package list
STOP="$TMP/stop"					# control "crash" file
SRC_DIR="$BD/sources"				# package file's folder
LOG="$BD/puppy-builder.log"			# log file (remember the bad things)

[ ! -e $TMP ]&& mkdir -p $TMP || rm -rf $TMP/*
L="################################"
clear
echo -e "\n $BN - $(date +'y%Y m%m d%d')\n\n $L\n" | tee $LOG


. $SCRIPT_DIR/00_check_commands
. $SCRIPT_DIR/01_check_free_space
. $SCRIPT_DIR/02_start_config
. $SCRIPT_DIR/03_download_database
. $SCRIPT_DIR/04_pkg_chooser
. $SCRIPT_DIR/05_pkg_expansion	# variator script

[ -e $STOP ]&& cat $STOP | tee -a $LOG

[ -e $STOP ]&& MESS0="stopped." || MESS0="succesfully finished."
echo -e "\n $L\n\n Build process $MESS0" | tee -a $LOG
echo
#for i in {10..0};do echo -ne "  Quit ${i}s  \r";sleep 1 ;done; echo -e "  Byebye \r"

sleep 30