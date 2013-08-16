#!/bin/bash

MS_IP=$1
MS_PORT=$2

FILE="${MS_IP}.log"
if [ -f $FILE ]; 
then
	echo "ok ${MS_IP}"
else
	echo "fail ${MS_IP}"
fi
