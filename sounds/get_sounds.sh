#!/bin/bash

V_MOH=1.0.52
V_EN=1.0.51
V_RU=1.0.51

if [ !$SND_RATE ]; then
	SND_RATE=(8000 16000 32000 48000)
fi

cd /sounds 

if [ ! -d /sounds/music ] && [ "$MOH" ]; then
	for i in ${SND_RATE[@]}; do
		wget -O - http://files-sync.freeswitch.org/releases/sounds/freeswitch-sounds-music-${i}-$V_MOH.tar.gz | gzip -dc - | tar xf -
	done
	chown -R freeswitch:freeswitch /sounds/music
fi

if [ ! -d /sounds/en ] && [ "$SND_EN" ]; then
	for i in ${SND_RATE[@]}; do
		wget -O - http://files-sync.freeswitch.org/releases/sounds/freeswitch-sounds-en-us-callie-${i}-$V_EN.tar.gz | gzip -dc - | tar xf -
	done
	chown -R freeswitch:freeswitch /sounds/en
fi

if [ ! -d /sounds/ru ] && [ "$SND_RU" ]; then
	for i in ${SND_RATE[@]}; do
		wget -O - http://files-sync.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-elena-${i}-$V_RU.tar.gz | gzip -dc - | tar xf -
	done
	chown -R freeswitch:freeswitch /sounds/ru
fi

exit 0
