#!/usr/bin/env bash

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && accountcreatehelp >&2
	echo "$1" >&2
	exit ${_ret}
}


# Function that evaluates whether a value passed to it begins by a character
# that is a short option of an argument the script knows about.
# This is required in order to support getopts-like short options grouping.
begins_with_short_option()
{
	local first_option all_short_options='fh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_full="off"

accountcreatehelp() {
  cat <<-HEREDOC
  Magento 2 Account Creation v1.0.2

  Create a user account and create the correct directories, nginx & PHP configuration.

  Usage: account-create.sh [-h|--help]
  Options:
    -h, --help: Prints help
HEREDOC
}

# The parsing of the command-line
parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			# See the comment of option '--full' to see what's going on here - principle is the same.
			-h|--help)
				accountcreatehelp
				exit 0
				;;
			# See the comment of option '-f' to see what's going on here - principle is the same.
			-h*)
				accountcreatehelp
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"
