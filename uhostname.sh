#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-02-21

if [ -z $UHOSTNAME_SH ]; then

UHOSTNAME_SH="uhostname.sh"

# Returns a hosts unique hostname ID string.
# Currently based on that there has to be at least one ethernet controller

function uhostname() {
	sudo ifconfig				| \
		egrep '^eth'			| \
		sort					| \
		head -n1				| \
		sed -e 's/.*HWaddr //'	| \
		tr ":" "_"
}

source s3.ebasename.sh

if [ "$UHOSTNAME_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	set -e

	#Temporarily, we dont need the following:
	#source s3.test_install_pkg.sh
	#source s3.user_response.sh
	#test_install_pkg mcrypt

	set -e
	uhostname
	exit $?
fi

fi
