#!/usr/bin/env bash


# Dev Note: Blank (no key) first to guide user to help.

# libsourcery-  [-] INFO: Intended to be sourced as a library
# -h, --help : Display help message


# libsourcery-manual
## NAME
##	libsourcery.sh  Demonstrate bash script as library.
##
## SYNOPSIS
##	libsourcery.sh -h
##
##	libsourcery.sh -v
##
##	libsourcery.sh -L
##
## DESCRIPTION
##	Intended to be sourced by another script, basic help and version reporting when executed as a script.
##
##	Arguments and Options:
##
##	-h       (base option) Display help message.
##	--help
##
##	-l       (base option) Display non-base options.
##	--list
##
##	-m       (base option) Display this manual.
##	--manual
##
##	-c       [RESERVED]
##	--config
##
##	-L               List library core defined functions; e.g. not "main()".
##	--List-functions
##
##	--log-level [RESERVED]
##
##	-s    [RESERVED]
##	--set
##
##	-v        (base option) Display version information.
##	--version
##
## EXPERT
##	The following environment variables can be set to affect execution:
##
##	- reportError       : Defaults to "echo" if not set, command to use when reporting error messages
##	- reportWarning     : Defaults to "echo" if not set, command to use when reporting warning messages
##	- reportCaution     : Defaults to ":" if not set, command to use when reporting caution messages
##	- reportInformation : Defaults to ":" if not set, command to use when reporting information and completion messages
##	- reportTelemetry   : Defaults to ":" if not set, command to use when reporting telemetry messages
##	- reportDebug       : Defaults to ":" if not set, command to use when reporting debug messages
##
## EXIT STATUS
##	0  : (normal) On success.
##	1+ : ERROR.
##	2  : ERROR: Invalid usage.
##
## DEPENDENCIES
##	echo(0|1)   : Built-in or POSIX echo.
##	egrep(1)    : POSIX egrep.
##	grep(1)     : POSIX grep.
##	less(1)     : GNU (common UNIX) less.
##	sort(1)     : POSIX sort.
##	tr(1)       : POSIX tr.


if [[ -z ${sourceBase} ]] ; then
	sourceBase="${0}"
fi


# libsourcery-version
# Save script name
SELF="${0}"
SEMVER_STRING="0.4.0"  # See URL: https://semver.org/


# Declare global variables
# libsourcery-defined-functions
libsourceryDefinedFunctions=(
	introspect_file
	introspect_self
	list_defined_functions  # Only works when libsourcery.sh is executed as a script; other functional equivalency left as an exercise for the reader.
)

declare -A libsourceryIntrospect=(
	[defined_functions]=5
	[main]=19
	[manual]=60
	[sourcery]=12
	[version]=4
)

# libsourcery-main
main () {
	# Description: Main control flow.
	# Arguments:
	#   ${@} : Argv.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	set_up_environment
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"
	process_command_line_options "${@}"
	shift $(( ${OPTIND} - 1 ))  # Shifting argv needs to occur in main() vice process_command_line_options()
	# Core actions
	introspect_libsourcery_with_key "${introspectKey}"
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


usage () {
	# Description: Generate and display usage.
	# References:
	#   - Albing, C., JP Vossen. bash Idioms. O'Reilly. 2022.
	# Arguments:
	#   ${1} : (Optional) Search term.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"
	searchTerm="${1}"
	shift
	# Core actions
	(
		echo "${SELF##*/}" 'Usage:'
		egrep '[[:space:]]\)[[:space:]]+#[[:space:]]' "${SELF}" | tr -s '\t' | sort
	) | grep -i "${searchTerm:-.}" | less
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


manual () {
	# Description: Display full manual.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"
	# Core actions
	grep -B 1 '[#][#][[:space:]]' "${SELF}" | less
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


version_info () {
	# Description: Output version information.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"
	# Core actions
	echo "${SELF##*/}" "${SEMVER_STRING}"
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


set_up_environment () {
	# Description: Set up environment.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	# Core actions
	: ${reportError:=echo}
	: ${reportWarning:=echo}
	: ${reportCaution:=:}
	: ${reportInformation:=:}
	: ${reportTelemetry:=:}
	: ${reportDebug:=:}
	: ${TMPDIR:=/tmp}
}


exit_error () {
	# Description: Output ${1} (error message) to stderr and exit with ${2} (error status).
	# Arguments:
	#   ${1} : Error message to write.
	#   ${2} : (Optional) Error status to exit with.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	errorStatus=1
	errorMessage="${1}"
	shift
	# Core actions
	"${reportError}" '[!] ERROR:' "${errorMessage}" >&2
	if [[ -n "${1}" ]] ; then
		errorStatus="${1}"
	fi
	exit "${errorStatus}"
}


report_warning () {
	# Description: Output ${1} (warning message) to stderr as warning.
	# Arguments:
	#   ${1} : Warning message to write.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	warningMessage="${1}"
	shift
	# Core actions
	"${reportWarning}" '[!] WARNING:' "${warningMessage}" >&2
}


report_caution () {
	# Description: Output ${1} (caution message) to stderr as caution.
	# Arguments:
	#   ${1} : Caution message to write.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	cautionMessage="${1}"
	shift
	# Core actions
	"${reportCaution}" '[^] CAUTION:' "${cautionMessage}" >&2
}


report_information () {
	# Description: Output ${1} (information message) to stderr as information.
	# Arguments:
	#   ${1} : Information message to write.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	informationMessage="${1}"
	shift
	# Core actions
	"${reportInformation}" '[-] INFO:' "${informationMessage}" >&2
}


report_complete () {
	# Description: Output ${1} (completion message) to stderr as information.
	# Arguments:
	#   ${1} : Completion message to write.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	completionMessage="${1}"
	shift
	# Core actions
	"${reportInformation}" '[+] INFO:' "${completionMessage}" >&2
}


report_telemetry () {
	# Description: Output ${1} (telemetry message) to stderr as telemetry.
	# Arguments:
	#   ${1} : Telemetry message to write.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	telemetryMessage="${1}"
	shift
	# Core actions
	"${reportTelemetry}" '[.] TELEMETRY:' "${SELF##*/}::${telemetryMessage}" >&2
}


report_debug () {
	# Description: Output ${1} (debug message) to stderr as debug.
	# Arguments:
	#   ${1} : Debug message to write.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	debugMessage="${1}"
	shift
	# Core actions
	"${reportDebug}" '[.] DEBUG:' "${debugMessage}" >&2
}


process_command_line_options () {
	# Description: Process command line arguments (argv) using getopts.
	# Arguments:
	#   ${@} : Argv.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"

	# Core actions

	# Developer Note: Short Option with Value
	#  - Example: -r value
	#    <shortOption> )
	#        exampleVar="${OPTARG}"
	#        ;;

	while getopts ':-:hlmLv' cmdLnToken ; do
		case ${cmdLnToken} in
			 h )     # (base option) Display help message.
				usage
				exit
				;;
			 l )     # (base option) List non-base options.
				list_non_base_options
				exit
				;;
			 m )       # (base option) Display manual.
				manual
				exit
				;;
			L )               # List library defined functions
				list_defined_functions
				;;
			 v )        # (base option) Display version information.
				version_info
				exit
				;;
			- )
				# Long Option Processing
				process_command_line_long_options "${OPTARG}" "${!OPTIND}"
				;;
			: )
				# ERROR: Required argument missing
				exit_error "Missing required argument to: -${OPTARG}" 2
				;;
			* )
				# Default: Blank or unknown token, report error in unknown command line token
				if [[ -n "${cmdLnToken}" ]] ; then
					exit_error "Unknown option: -${OPTARG}" 2
				fi
				;;
		esac
	done
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


process_command_line_long_options () {
	# Description: Process command line long option arguments based on getopts parsing.
	# Arguments:
	#   ${1} : Argument from argv being processed.
	#   ${2} : Next argument in argv.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"
	longOptionToken="${1}"
	shift
	longOptionArgument="${1}"
	shift

	# Core actions

	# Developer Note: Long Options with Value
	#  - Example: --long-option=value --- SHALL appear before "--long-option value" code block
	#    <longOption>=* )
	#        exampleVar="${longOptionToken#longOption=}"
	#        ;;
	#  - Example: --long-option value
	#    <longOption> )
	#        exampleVar="${longOptionArgument}"
	#        let OPTIND++
	#        ;;

	case ${longOptionToken} in
		 help )  # (base option)
			usage
			exit
			;;
		 list )  # (base option)
			list_non_base_options
			exit
			;;
		List-functions )  # .
			list_defined_functions
			;;
		 manual )  # (base option)
			manual
			exit
			;;
		read=* )
			sourceFile="${longOptionToken#*=}"
			;;
		read )
			sourceFile="${longOptionArgument}"
			let OPTIND++
			;;
		 version )  # (base option)
			version_info
			exit
			;;
		* )
			if [[ -n "${longOptionToken}" ]] ; then
				exit_error "Unknown option: --${longOptionToken}" 2
			fi
			;;
	esac
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


list_non_base_options () {
	# Description: Generate and display list of non-base options.
	# References:
	#   - Albing, C., JP Vossen. bash Idioms. O'Reilly. 2022.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"
	# Core actions
	(
		echo "${SELF##*/}" 'Non-Base Options:'
		egrep '[[:space:]]\)[[:space:]]+#[[:space:]]' "${SELF}" | grep -v 'base[[:space:]]option' | tr -s '\t' | sort
	) | less
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


list_defined_functions () {
	# Description: List functions defined in this library.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${SELF##*/}::${FUNCNAME[0]}(${*})"
	# Core actions
	introspect_self "libsourcery-defined-functions" $(( "${#libsourceryDefinedFunctions[@]}" + 2 ))
	report_debug "${SELF##*/}::${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


introspect_file () {
	# Description: Introspect ${1} (filename) using grep, search for ${2} (regex pattern) showing ${3} (number) lines after match for ${4} (max count) match occurrence(s).
	# Arguments:
	#   ${1} : Path/filename to search through.
	#   ${2} : regex pattern to search for, defaults to "." (match any single character).
	#   ${3} : Number of lines to show after match, defaults to 1.
	#   ${4} : Max number of match occurrences, defaults to 1.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${FUNCNAME[0]}(${*})"
	filename="${1}"
	shift
	regexPattern="${1}"
	shift
	linesAfter="${1}"
	shift
	maxCount="${1}"
	shift
	# Core actions
	grep -n -B 1 -A "${linesAfter:-1}" -m "${maxCount:-1}" "${regexPattern:-.}" "${filename}"
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


introspect_self () {
	# Description: Introspect ${SELF} using grep, search for ${1} (regex pattern) showing ${2} (number) lines after match for ${3} (max count) match occurrence(s).
	# Arguments:
	#   ${1} : regex pattern to search for, defaults to "." (match any single character).
	#   ${2} : Number of lines to show after match, defaults to 1.
	#   ${3} : Max number of match occurrences, defaults to 1.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${FUNCNAME[0]}(${*})"
	regexPattern="${1}"
	shift
	linesAfter="${1}"
	shift
	maxCount="${1}"
	shift
	# Core actions
	introspect_file "${SELF}" "${regexPattern:-.}" "${linesAfter:-1}" "${maxCount:-1}"  "${SELF}"
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


introspect_libsourcery_with_key () {
	# Description: Introspect bash_pro_shop with ${1} (key).
	# Arguments:
	#   ${1} : Target to introspect.
	#   ${2} : Key to use for introspection.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${FUNCNAME[0]}(${*})"
	key="${1}"
	shift
	# Core actions
	# Lookup count to use for lines after for 'key'
	case ${key} in
		defined-functions )
			linesAfter="${libsourceryIntrospect[defined_functions]}"
			;;
		main )
			linesAfter="${libsourceryIntrospect[main]}"
			;;
		sourcery )
			linesAfter="${libsourceryIntrospect[sourcery]}"
			;;
		version )
			linesAfter="${libsourceryIntrospect[version]}"
			;;
	esac
	introspect_file "${sourceBase%%/*}/libsourcery.sh" "libsourcery-${key}" "${linesAfter}"
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


# libsourcery-sourcery
# Developer Note: This script supports running as a script like normal and sourcing as a library.
# 1. Change the below variable name to a unique ID for this script.
#    - Recommendation: Change "_THIS_" to the name of this scirpt
#    - E.g. ${source__THIS__as_library} --> ${source_libsourcery_as_library}
# 2. Assign a value to the uniquely named variable in the script you want to source this library from.
#    - E.g. source_libsourcery_as_library=y
# 3. Source this script in the other script referencing this script as a library
#    - E.g. source libsourcery.sh
# NOTE: bash does not have the concept of namespaces, name collisions will overwrite previous assignments when sourced.
if [[ -z ${source_libsourcery_as_library} ]] ; then
	main "${@}"
fi
