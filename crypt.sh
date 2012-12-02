#!/bin/bash
#
# Will tar/untar and encrypt/decrypt file or directory
# Script will determine whichever itself by
# inspecting the extension (if any) of the first argument.
# Normal usage is:
# util.crypt.sh mydir yourkeystring
# util.crypt.sh mydir.tar.gz yourkeystring

if [ -z $CRYPT_SH ]; then

CRYPT_SH="crypt.sh"

# Tar the named directory in $1 with the key $2
# Optional 3:rd parameter adds a tag string to the filename generated.
function crypt_pack()
{
	if [ -z $3 ]; then
	tar -zcf - $1 | openssl des3 -salt -k $2 | \
		dd of=$1.des3
	else
	tar -zcf - $1 | openssl des3 -salt -k $2 | \
		dd of=$1_$3.des3
	fi
}

# Un-tar the named file $1 with the key $2
function crypt_unpack()
{
	echo "1=$1"
	echo "2=$2"
	dd if=$1 |openssl des3 -d -k $2 | tar zxf -
}

source s3.ebasename.sh

if [ "$CRYPT_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	source s3.user_response.sh

	set -e
	#set -u

	if [ "X$( which openssl )" == "X" ]; then
		set +u
		ask_user_continue \
			"Detected that opnssl isn't installed. Continue by install it fist? (Y/n)" || exit $?

		set -u
		sudo apt-get install openssl
	fi

	if [ $# -lt 2 ]; then
		echo "Snytax error: $( basename $0 ) [directory|package-file] [key] [<extra suffix>]"
		exit 1
	fi

	EXT=$(echo $1 | sed -e 's/^.*\.//')
	echo $EXT
	if [ "x${EXT}" == "xdes3" ]; then
		crypt_unpack "$@"
	else
		crypt_pack "$@"
	fi
	exit $?
fi

fi
