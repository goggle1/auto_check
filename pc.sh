#!/bin/bash

MS_LIST="./pc.list"
MOBILE_LIST="./mobile_key_password.list"

function ms_get_config()
{
	LOGIN_IP=$1
	LOGIN_PORT=5044
	LOGIN_KEY=$2
	LOGIN_PASS=$3
	
	KEY_FILE="secrets/$LOGIN_KEY"
	#./expect.sh $LOGIN_IP $LOGIN_PORT $KEY_FILE "${LOGIN_PASS}"
}

function ms_check_config()
{
	MS_IP=$1
	MS_PORT=$2
	#./check.sh $MS_IP $MS_PORT
	COUNT=`grep "$MS_IP" $MOBILE_LIST | wc -l`
	echo "$MS_IP,$COUNT"
}

function do_line()
{
	LINE=$1
	echo $LINE
	PLATFORM=`echo $LINE|awk -F"," '{print $13}'`
	if [ x"${PLATFORM}" = x"pc" ];
	then
		MS_IP=`echo $LINE|awk -F"," '{print $3}'`
		MS_PORT=`echo $LINE|awk -F"," '{print $4}'`
		MS_IP2=`echo $LINE|awk -F"," '{print $5}'`
		MS_PORT2=`echo $LINE|awk -F"," '{print $6}'`
		KEY=`echo $LINE|awk -F"," '{print $14}'`
		PASSWORD=`echo $LINE|awk -F"," '{print $15}'`
		ms_get_config $MS_IP2 $KEY $PASSWORD
		ms_check_config $MS_IP2 $MS_PORT
	fi
}

while read LINE
do
	do_line ${LINE}
done < ${MS_LIST}
