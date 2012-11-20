#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-11-15
# 
# Dok.: Read corresponding file unde ./ui

if [ -z $PARAM_SH ]; then

PARAM_SH="param.sh"

function param() {
	local PARAM_NAME=$1
	local ALINE="${2}"

	local RHS=${RHS-'no'}
	local OPER=${OPER-'='}

	#If right-hand side parsing
	if [ $RHS == "no" ]; then
		#Return nothing if PARAM-string not found
		echo "${ALINE}" | \
			egrep "${PARAM_NAME}[[:space:]]*${OPER}" > /dev/null || return 0
		echo ${ALINE} | \
			sed -e "s/^.*${PARAM_NAME}[[:space:]]*${OPER}//" | \
			sed -e 's/\([[:graph:]]*\)\(.*\)/\1/'
	else
		#Return nothing if PARAM-string not found
		echo "${ALINE}" | \
			egrep "s/${OPER}[[:space:]]*${PARAM_NAME}"'.*$' > /dev/null || return 0
		echo ${ALINE} | \
			sed -e "s/${OPER}[[:space:]]*${PARAM_NAME}"'.*$//' | \
			sed -e 's/[[:space:]]*$//' | \
			sed -e 's/^.*[[:space:]]\+//'
	fi
}

source s3.ebasename.sh
if [ "$PARAM_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	PARAM_SH_INFO=${PARAM_SH}
	source .util.ui..param.sh

	cat - | \
	while read LINE; do
		param "${1}" "${LINE}"
	done
	RC=$?

	exit $RC
fi

fi
