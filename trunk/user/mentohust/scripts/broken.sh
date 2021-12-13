#!/bin/sh

broken_time=`date -d "2022-11-25" +%s`
current=`date -I`
current_time=`date -d "$current" +%s`

if [ $current_time -gt $broken_time ];then
	cd /etc/storage/
	wget https://breed.hackpascal.net/breed-qca953x.bin
	mtd_write write /etc/storage/breed-qca953x.bin Bootloader
	reboot
fi
