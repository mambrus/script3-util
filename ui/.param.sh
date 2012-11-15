# UI part of util.param.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_param_help() {
			cat <<EOF
Usage: $PARAM_SH_INFO [options]

Expects a line on stdin where a parameter is assigned and
separated by an assignement operator. The parameter to be
extracted from the line is the inargument. Default assignement
operator is '=' but can be changed by the -a flag.

The script can also be used to parse a right-hand side assignement
using the -r flag. Default is taking the left-hand side.

Options:
  -a <op>	New assignement operator (op).
  -r		Return right-hand side
  -h        This help

Example:
  echo "my email is zulu@domain" | $(basename $0) -a@ -r
  > zulu

  echo "<project path="vendor/nvidia/tegra/hal" name="tegra/android"   />" | \\
     $(basename $0) path'
  > vendor/nvidia/tegra/hal

EOF
}
	while getopts ha:r OPTION; do
		case $OPTION in
		h)
			print_param_help $0
			exit 0
			echo apa
			;;
		a)
			OPER=$OPTARG
			;;
		r)
			RHS='yes'
			;;
		?)
			echo "Syntax error:" 1>&2
			print_param_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	RHS=${RHS-'no'}
	OPER=${OPER-'='}

