#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-11-15
# 
# Dok.: Read corresponding file unde ./ui

if [ -z $PARAM_SH ]; then

PARAM_SH="param.sh"

function param() {
	local PARAM_NAME=$1

	local RHS=${RHS-'no'}
	local OPER=${OPER-'='}

	if [ $RHS == "no" ]; then
		sed -e "s/^.*${PARAM_NAME}[[:space:]]*${OPER}//" | \
			sed -e 's/\([[:graph:]]*\)\(.*\)/\1/'
	else
		sed -e "s/${OPER}[[:space:]]*${PARAM_NAME}"'.*$//' | \
			sed -e 's/[[:space:]]*$//' | \
			sed -e 's/^.*[[:space:]]\+//'
	fi

#Not as good solution follows. Can't handle whitespace properly
#	if [ $RHS == "no" ]; then
#		sed -e "s/^.*${PARAM_NAME}//" | \
#			cut -f2 -d"${OPER}" | \
#			cut -f1 -d" "
#	fi
}

source s3.ebasename.sh
if [ "$PARAM_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	PARAM_SH_INFO=${PARAM_SH}
	source .util.ui..param.sh

	param "$@"
	RC=$?

	exit $RC
fi

fi
