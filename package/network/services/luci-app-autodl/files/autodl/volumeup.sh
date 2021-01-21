#!/bin/sh

xmgetspkdev=$(amixer | grep 'Simple mixer control' | grep -e 'Speaker' -e 'PCM' -e 'Master' | cut -d "'" -f 2)
getcurrentvolume=$(amixer get $xmgetspkdev | tail -n 1 | cut -d ' ' -f 6)
if [ "$xmgetspkdev" == "Speaker" ];then
	volumestep=3
elif [ "$xmgetspkdev" == "PCM" ];then
	volumestep=8
else
	volumestep=5
fi
volume=$getcurrentvolume

if [ "$xmgetspkdev" == "Speaker" ];then
	if [ $volume -lt 30 ];then
		volume=$(echo `expr $volume + $volumestep`)
		volumeup=$volume
		amixer -q set Speaker $volumeup
	fi
elif [ "$xmgetspkdev" == "PCM" ];then
	if [ $volume -lt 128 ];then
		volume=$(echo `expr $volume + $volumestep`)
		volumeup=$volume
		amixer -q set PCM $volumeup
	fi
else
	if [ $volume -lt 128 ];then
		volume=$(echo `expr $volume + $volumestep`)
		volumeup=$volume
		amixer -q set Master $volumeup
	fi
fi

