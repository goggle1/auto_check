#!/bin/bash

MS_IP=$1
MS_PORT=$2

function check_download()
{
	FILE="${MS_IP}.log"
	DAT_LIST=`cat ${FILE} | grep "^/media"`
	for DAT in $DAT_LIST
	do
		#echo "$DAT"
		DAT_FILE=`echo $DAT|awk -F"/" '{print $3}'`
		DAT_NAME=`echo $DAT_FILE|awk -F"." '{print $1}'`
		#curl -v -r 0-499 http://${MS_IP}:${MS_PORT}/${DAT_NAME}.mp4 -o ${MS_IP}_${MS_PORT}_${DAT_NAME}.mp4
		DOWNLOAD_FILE="${MS_IP}_${MS_PORT}_${DAT_NAME}.mp4"
		if [ -f $DOWNLOAD_FILE ];
		then
			echo "ok_download $MS_IP $MS_PORT $DAT"
		else
			echo "fail_download $MS_IP $MS_PORT $DAT"
		fi
	done
}

function do_download()
{
	FILE="${MS_IP}.log"
	DAT_LIST=`cat ${FILE} | grep "^/media"`
	for DAT in $DAT_LIST
	do
		echo "$DAT"
		DAT_FILE=`echo $DAT|awk -F"/" '{print $3}'`
		DAT_NAME=`echo $DAT_FILE|awk -F"." '{print $1}'`
		curl -v -r 0-499 http://${MS_IP}:${MS_PORT}/${DAT_NAME}.mp4 -o ${MS_IP}_${MS_PORT}_${DAT_NAME}.mp4
	done
}

function check_log()
{
	FILE="${MS_IP}.log"
	if [ -f $FILE ]; 
	then
		echo "ok ${MS_IP}"
		check_download ${MS_IP} ${MS_PORT}
	else
		echo "fail ${MS_IP}"
	fi
}

check_log ${MS_IP} ${MS_PORT}
