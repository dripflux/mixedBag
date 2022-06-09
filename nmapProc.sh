#!/usr/bin/env bash


# NAME
#	nmapProc.sh  ...
#
# SYNOPSIS
#	nmapProc.sh help
#
#	nmapProc.sh <subcommand> <target_specification>
#
# DESCRIPTION
#	...
#
#	Subcommands:
#
#	help  (common) Display help message, supports single term filtering.
#
#	ls, list  (common) Display non-common subcommands.
#
# EXIT STATUS
#	0  : (normal) On success
#	1+ : ERROR
#	2  : ERROR: Invalid usage
#
# DEPENDENCIES
#	basename(1) : POSIX basename
#	echo(0|1)   : Builtin or POSIX echo
#	egrep(1)    : POSIX egrep
#	grep(1)     : POSIX grep
#	less(1)     : GNU (common UNIX) less
#	tr(1)       : POSIX tr


# Save script name
SELF="${0}"


main () {
	# Description: Main control flow
	# Arguments:
	#   ${1}  : Subcommand
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	subcommand="${1}"
	shift
	setUpEnv
	# Core actions
	case ${subcommand} in
		help )       # (common) Display this help message, supports single term filtering
			searchTerm="${1}"
			usage "${searchTerm}"
			;;
		ls | list )  # (common) List non-common subcommands
			listNonCommonSubcommands
			;;
		* )
			# Default: Blank or unknown subcommand, report error if unknown subcommand
			# Note: Lack of comment on same line as case, default action will not be displayed by usage or ls subcommand
			usage
			if [[ -n "${subcommand}" ]] ; then
				errorExit "ERROR: Unknown subcommand: ${subcommand}" 2
			fi
			;;
	esac
}


usage () {
	# Description: Generate and display usage
	# References: Albing, C., JP Vossen. bash Idioms. O'Reilly. 2022.
	# Arguments:
	#   ${1} : (Optional) Search term
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	searchTerm="${1}"
	shift
	# Core actions
	(
		echo $( basename "${SELF}" ) 'Usage:'
		egrep '\)[[:space:]]+# ' "${SELF}" | tr -s '\t'
	) | grep "${searchTerm:-.}" | less
}


errorExit () {
	# Description: Output ${1} (error message) to stderr and exit with ${2} (error status).
	# Arguments:
	#   ${1} : Error message to write
	#   ${2} : (Optional) Error status to exit with
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	errorStatus=1
	errorMessage="${1}"
	shift
	# Core actions
	echo "${errorMessage}" >&2
	if [[ -n "${1}" ]] ; then
		errorStatus="${1}"
	fi
	cleanUpArtifacts
	exit "${errorStatus}"
}


warningReport () {
	# Description: Output ${1} (warning message) to stderr, but DO NOT exit.
	# Arguments:
	#   ${1} : Warning message to write
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	warningMessage="${1}"
	shift
	# Core actions
	echo "${warningMessage}" >&2
}


listNonCommonSubcommands () {
	# Description: Generate and display list of non-common subcommands
	# References: Albing, C., JP Vossen. bash Idioms. O'Reilly. 2022.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	:
	# Core actions
	(
		echo $( basename "${SELF}" ) 'Subcommands:'
		egrep '\)[[:space:]]+# ' "${SELF}" | tr -d '\t'
	) | grep -v "(common)" | less
}


setUpEnv () {
	# Description: Set up environment
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	:
	# Core actions
	if [[ -z "${TMPDIR}" ]] ; then
		TMPDIR='/tmp/'
	fi
}


cleanUpArtifacts () {
	# Description: Clean up artifacts from actions
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	:
	# Core actions
	removeTempFiles
}


removeTempFiles () {
	# Description: Remove temporary files from filesystem
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	# Set up working set
	:
	# Core actions
	:
}


main "${@}"
