#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-26

# This script prints the manifest beloning to the project you stand in (or point
# at)

if [ -z $PARAM_SH ]; then

PARAM_SH="param.sh"

function param() {
	echo "tbd"
}

source s3.ebasename.sh
if [ "$PARAM_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	PARAM_SH_INFO=${PARAM_SH}
	source .util.ui..param.sh
	
	cd ${START_DIR}
	param "$@"
	RC=$?

	exit $RC
fi

fi
