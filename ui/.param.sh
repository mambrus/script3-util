# UI part of util.param.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_param_help() {
			cat <<EOF
Usage: $PARAM_SH_INFO [options] <parameter> [<parameter> ..]

Expects a line on stdin where a parameter is assigned and
separated by an assignement operator. The parameter to be
extracted from the line is the inargument. Default assignment
operator is '=' but can be changed with the -a flag.

The script can also be used to parse a right-hand side assignment
using the -r flag. Default is taking the left-hand side.

Options:
  -a <op>   Assignment operator (op).
  -r        Return right-hand side
  -F <FS>   Field output separator. Implicily also means parameters should be
            output on the same line. This only makes sense if scanning for more
            parameters than one. Separator separates output, nut never ends a
			line. If you find a separator ending a line it means last parameter
			wasn't found. Note that field separator can be a string, sometimes
			usable for more readable output.
  -f <name> Read input from this file instead of stdin.
  -h        This help

Example:
  echo "my email is zulu@domain now" | $(basename $0) -a@ -r "domain"
  > zulu

  echo "<project path="vendor/nvidia/tegra/hal" name="tegra/android"   />" | \\
     $(basename $0) path
  > vendor/nvidia/tegra/hal

  xpra info :20 > /tmp/test
  $(basename $0) -f/tmp/test -F";" \\
     session_name \\
     clients \\
     client_connection \\
     start_time
  > xeyes_23441;0;;1358092413
  (The above example obviously requires a running xpra session at :20 running)

  cat .repo/default.xml | $(basename $0) -F";" name path
  # Produces a list of a manifest file with a specific order of the parameters
  # "name" and "path"

EOF
}
	while getopts ha:rF:f: OPTION; do
		case $OPTION in
		h)
			clear
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
		F)
			FS=$OPTARG
			ONE_LINE_OUTPUT='yes'
			;;
		f)
			FNAME=$OPTARG
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
	ONE_LINE_OUTPUT=${ONE_LINE_OUTPUT-'no'}
	FNAME=${FNAME-'--'}

	if [ $# -eq 0 ]; then
		echo "Syntax error: At least one argument needed" 1>&2
		print_param_help $0 1>&2
		exit 2
	fi
