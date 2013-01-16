#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-11-15
#
# Documentation: Read corresponding file under ./ui

if [ -z $PARAM_SH ]; then

PARAM_SH="param.sh"

function param() {
	local PARAM_NAME=$1
	local ALINE=$(echo "${2}" | \
		sed -e 's/\([[:space:]]*<\)\(.*\)\(\/>[[:space:]]*$\)/\2/' | \
		sed -e 's/\([[:space:]]*<[^!]\)\(.*\)\(>[[:space:]]*$\)/\2/'
	)

	local RHS=${RHS-'no'}
	local OPER=${OPER-'='}

	#If right-hand side parsing
	if [ $RHS == "no" ]; then
		#Return nothing if PARAM-string not found
		echo "${ALINE}" | \
			egrep "([[:space:]]|^)${PARAM_NAME}[[:space:]]*${OPER}" > \
				/dev/null || return 0
		echo ${ALINE} | \
			sed -e "s/^.*${PARAM_NAME}[[:space:]]*${OPER}//" | \
			sed -e 's/\([[:graph:]]*\)\(.*\)/\1/'
	else
		#Return nothing if PARAM-string not found
		echo "${ALINE}" | \
			egrep "${OPER}[[:space:]]*${PARAM_NAME}([[:space:]]|$)" > \
				/dev/null || return 0
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

	NARGS=$#
	ARG_ARRY=("$@")
	if [ "X${UNTIL_EOF=}" == "Xyes" ]; then
		TEXT_MASS=$(cat  ${FNAME})
		CMD="echo ${TEXT_MASS}"
	else
		CMD="cat  ${FNAME}"
	fi
	${CMD} | while read ALINE; do
		if [ "X${ONE_LINE_OUTPUT}" != "Xyes" ]; then
			for (( i=0; i<$NARGS; i++ )); do
				param "${ARG_ARRY[$i]}" "${ALINE}"
				RC=$? || exit $RC
			done
		else
			(for (( i=0; i<$NARGS; i++ )); do
				echo -n $(param "${ARG_ARRY[$i]}" "${ALINE}")"${FS}"
				RC=$? || exit $RC
			done
			echo) | sed -e "s/${FS}\$//"
		fi
	done

	exit $RC
fi

fi
