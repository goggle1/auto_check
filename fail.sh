#!/bin/bash

DAY=20
MONTH=08
YEAR=2013

PATH_ROOT="${YEAR}${MONTH}${DAY}"
PATH_BY_MS="${PATH_ROOT}/by_ms"
PATH_BY_CLIENT="${PATH_ROOT}/by_client"
PATH_BY_ERRNO="${PATH_ROOT}/by_errno"

mkdir ${PATH_ROOT}
mkdir ${PATH_BY_MS}
mkdir ${PATH_BY_CLIENT}
mkdir ${PATH_BY_ERRNO}

SRC_FILE="/media2/log_project/oxeye/ecom_mobile/fbuffer/${YEAR}/${MONTH}/${DAY}/logdata_${YEAR}${MONTH}${DAY}_loc.result"
DST_FILE="${PATH_ROOT}/fail.list"

awk -F"," '{if($9!=0) print $0 }' ${SRC_FILE} > ${DST_FILE}
awk -F"," '{if(length($5)>0) print $0 > '$PATH_ROOT'"/by_ms/"$5}' ${DST_FILE}
awk -F"," '{if(length($2)+length(3)>0) print $0 > '$PATH_ROOT'"/by_client/"$2"_"$3 }' ${DST_FILE}
awk -F"," '{if($9!=0) print $0 > '$PATH_ROOT'"/by_errno/err"$9 }' ${DST_FILE}

cd ${PATH_ROOT}
cd by_ms
#wc -l ${PATH_BY_MS}/* | sort -n -r > "${PATH_ROOT}/fail_ms.list"
wc -l * | sort -n -r > "../fail_ms.list"
cd ..
cd ..

cd ${PATH_ROOT}
cd by_client
#wc -l ${PATH_BY_CLIENT}/* | sort -n -r > "${PATH_ROOT}/fail_client.list"
wc -l * | sort -n -r > "../fail_client.list"
cd ..
cd ..

cd ${PATH_ROOT}
cd by_errno
#wc -l ${PATH_BY_ERRNO}/* | sort -n -r > "${PATH_ROOT}/fail_errno.list"
wc -l * | sort -n -r > "../fail_errno.list"
cd ..
cd ..

awk '{if($1>1000) print " | "$1" | "$2" | " }' "${PATH_ROOT}/fail_ms.list" > "${PATH_ROOT}/fail_ms.result.${YEAR}${MONTH}${DAY}"   
awk '{if($1>1000) print " | "$1" | "$2" | " }' "${PATH_ROOT}/fail_client.list" > "${PATH_ROOT}/fail_client.result.${YEAR}${MONTH}${DAY}"  
awk '{if($1>0) print " | "$1" | "$2" | " }' "${PATH_ROOT}/fail_errno.list" > "${PATH_ROOT}/fail_errno.result.${YEAR}${MONTH}${DAY}"  
