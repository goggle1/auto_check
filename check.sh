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
		SRC_FILE="http://${MS_IP}:${MS_PORT}/${DAT_NAME}.mp4"
		DST_FILE="${MS_IP}_${MS_PORT}_${DAT_NAME}.mp4"
		#curl -v -r 0-499 ${SRC_FILE} -o ${DST_FILE}
		if [ -f $DST_FILE ];
		then
			echo "ok download $MS_IP $MS_PORT $DAT"
		else
			echo "fail download $MS_IP $MS_PORT $DAT"
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
		SRC_FILE="http://${MS_IP}:${MS_PORT}/${DAT_NAME}.mp4"
		DST_FILE="${MS_IP}_${MS_PORT}_${DAT_NAME}.mp4"
		curl -v -r 0-499 ${SRC_FILE} -o ${DST_FILE}
		if [ -f $DST_FILE ];
		then
			echo "ok download $MS_IP $MS_PORT $DAT"
		else
			echo "fail download $MS_IP $MS_PORT $DAT"
			break
		fi
	done
}

function check_log()
{
	FILE="${MS_IP}.log"
	if [ -f $FILE ]; 
	then
		echo "ok ${MS_IP}"
		#do_download ${MS_IP} ${MS_PORT}
		#check_download ${MS_IP} ${MS_PORT}
	else
		echo "fail ${MS_IP}"
	fi
}

check_log ${MS_IP} ${MS_PORT}
