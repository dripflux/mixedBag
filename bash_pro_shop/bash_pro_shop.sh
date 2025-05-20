#!/usr/bin/env bash


# Dev Note: Blank (no key) first to guide user to help.

# bash_pro-
# -h, --help : Display help message


# bash_pro-manual
## NAME
##	bash_pro_shop.sh  Bash better.
##
## SYNOPSIS
##	bash_pro_shop.sh -h
##
##	bash_pro_shop.sh --manual
##
## DESCRIPTION
##	Demo techniques to advance your Bash practices.
##
##	Arguments and Options:
##
##	-h            0x00 (base option) Display help message.
##	--help
##
##	-l       (base option) Display non-base options.
##	--list
##
##	-m            0x01 (base option) Display this manual [manual].
##	--manual
##
##	-B            0x?? Demo no basename(1) needed.
##	--Baseless
##
##	-c       [RESERVED]
##	--config
##
##	-d            0x?? Demo no dirname(1) needed.
##	--dir
##
##	-D            0x?? Demo debug and other message techniques.
##
##	-F            0x?? Discuss future work.
##	--Future
##
##	-f            0x?? Demo functions as a foundation.
##	--funcs
##
##	-i <key>           Introspect this program with 'key'.
##	--introspect=<key>
##	--introspect <key>
##
##	-L <key>           Introspect libsourcery.sh with 'key'.
##	--LibIntro=<key>
##	--LibIntro <key>
##
##	--log-level [RESERVED]
##
##	-n            0x?? Demo naming conventions
##	--naming
##
##	-o            0x?? Demo options using getopts.
##	--options
##
##	-R        [RESERVED]
##	--recurse
##
##	-r            0x02 List references.
##	--refs
##
##	-S            0x?? Demo source to use library.
##	--Sourcery
##
##	-s            [FUTURE] 0x?? Demo use of symlink.
##	--symlink
##
##	-t            0x?? Demo tabs for indentation.
##	--tabs-indent
##
##	-v            0x03 (base option) Display version information [version].
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


# bash_pro-sourcery
# Source required libraries
sourceBase="${0}"
source_libsourcery_as_library=y
source "${sourceBase%%/*}/libsourcery.sh"


# bash_pro-version
# Save script name
SELF="${0}"
SEMVER_STRING="0.5.0"  # See URL: https://semver.org/


# Declare global variables
declare -A bashProIntrospect=(
	[main]=19
	[manual]=88
	[sourcery]=5
	[version]=4
	[func_vers]=16
)


# bash_pro-main
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
	report_debug "${FUNCNAME[0]}(${*})"
	process_command_line_options "${@}"
	shift $(( ${OPTIND} - 1 ))  # Shifting argv needs to occur in main() vice process_command_line_options()
	# Core actions
	introspect_target_with_key "${introspectTarget}" "${introspectKey}"
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
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
	report_debug "${FUNCNAME[0]}(${*})"
	searchTerm="${1}"
	shift
	# Core actions
	(
		echo "${SELF##*/}" 'Usage:'
		egrep '[[:space:]]\)[[:space:]]+#[[:space:]]' "${SELF}" | tr -s '\t' | sort
	) | grep -i "${searchTerm:-.}" | less
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
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
	report_debug "${FUNCNAME[0]}(${*})"
	# Core actions
	grep -B 1 '[#][#][[:space:]]' "${SELF}" | less
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}

# bash_pro-func_vers
version_info () {
	# Description: Output version information.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${FUNCNAME[0]}(${*})"
	# Core actions
	echo "${SELF##*/}" "${SEMVER_STRING}"
	"${sourceBase%%/*}/libsourcery.sh" -v
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
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
	introspectTarget='self'
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
	"${reportError}" '[!] ERROR:' "${SELF##*/}::${errorMessage}" >&2
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
	"${reportWarning}" '[!] WARNING:' "${SELF##*/}::${warningMessage}" >&2
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
	"${reportCaution}" '[^] CAUTION:' "${SELF##*/}::${cautionMessage}" >&2
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
	"${reportInformation}" '[-] INFO:' "${SELF##*/}::${informationMessage}" >&2
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
	"${reportInformation}" '[+] INFO:' "${SELF##*/}::${completionMessage}" >&2
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
	"${reportDebug}" '[.] DEBUG:' "${SELF##*/}::${debugMessage}" >&2
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

	while getopts ':-:hlmBDdFfI:i:norSstv' cmdLnToken ; do
		case ${cmdLnToken} in
			 h )     # 0x00 (base option) Display help message.
				usage
				exit
				;;
			 l )     # (base option) List non-base options.
				list_non_base_options
				exit
				;;
			 m )       # 0x01 (base option) Display manual [manual].
				manual
				exit
				;;
			B )         # 0x?? No basename.
				;;
			D  )  # 0x?? No dirname.
				;;
			d )          # 0x?? Demo debug and other message techniques.
				;;
			f )      # 0x04 Functions.
				introspectKey='main'
				;;
			i )             # Introspect this program with 'key', [<<key>>].
				introspectKey="${OPTARG}"
				;;
			L )             # Introspect libsourcery.sh with 'key', [<<key>>].
				introspectTarget='libsourcery'
				introspectKey="${OPTARG}"
				;;
			n )       # 0x?? Naming Conventions.
				;;
			o )        # 0x?? Options.
				;;
			r )     # 0x02 List references.
				list_references
				;;
			S )        # 0x?? Source as a library.
				;;
			# s )
			#	 ;;
			t )            # 0x?? Tabs for alignment.
				;;
			 v )        # 0x03 (base option) Display version information [version].
				version_info
				exit
				;;
			W )  # 0x?? FUTURE work.
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
	report_debug "${FUNCNAME[0]}(${*})"
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
		 help )  #      (base option)
			usage
			exit
			;;
		 list )  # (base option)
			list_non_base_options
			exit
			;;
		 manual )  #      (base option)
			manual
			exit
			;;
		Baseless )  #      .
			;;
		debugging )  #      .
			;;
		funcs )  #      .
			;;
		introspect=* )  # .
			introspectKey="${longOptionToken#introspect=}"
			;;
		introspect )    # .
			introspectKey="${longOptionArgument}"
			let OPTIND++
			;;
		LibIntro=* )  # .
			introspectTarget='libsourcery'
			introspectKey="${longOptionToken#introspect=}"
			;;
		LibIntro )    # .
			introspectTarget='libsourcery'
			introspectKey="${longOptionArgument}"
			let OPTIND++
			;;
		naming )  #      .
			;;
		options )  #      .
			;;
		read=* )
			sourceFile="${longOptionToken#read=}"
			;;
		read )
			sourceFile="${longOptionArgument}"
			let OPTIND++
			;;
		refs )  #      .
			list_references
			;;
		Sorcery )  #      .
			;;
		# symlink )
		# 	;;
		tabs-indent )  #      .
			;;
		 version )  #      (base option)
			version_info
			exit
			;;
		* )
			if [[ -n "${longOptionToken}" ]] ; then
				exit_error "Unknown option: --${longOptionToken}" 2
			fi
			;;
	esac
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
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
	report_debug "${FUNCNAME[0]}(${*})"
	# Core actions
	(
		echo "${SELF##*/}" 'Non-Base Options:'
		egrep '[[:space:]]\)[[:space:]]+#[[:space:]]' "${SELF}" | grep -v 'base[[:space:]]option' | tr -s '\t' | sort
	) | less
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


list_references () {
	# Description: List references.
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${FUNCNAME[0]}(${*})"
	# Core actions
	echo "- Albing, C., JP Vossen. Bash Cookbook. O'Reilly. November 23, 2017."
	echo "- Albing, C., JP Vossen. Bash Idioms. O'Reilly. April 19, 2022."
	echo '- Engelbart, Douglas C.; English, William K. "A research center for augmenting human intellect". AFIPS Fall Joint Computer Conference. 33: 395–410. December 9, 1968.'
	echo '- Fox, B., C. Ramey. Bash: help. Version 5.2.'
	echo '- man. "Online Manual Documentation Pages."'
	echo "- Robbins, A. Bash Pocket Reference. O'Reilly. April 5, 2016."
	echo "- Troncone, P., C. Albing. Cybersecurity Ops with Bash. O'Reilly. May 14, 2019."
	introspectKey=CANX
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


introspect_target_with_key () {
	# Description: Introspect ${1} (target) with ${2} (key).
	# Arguments:
	#   ${1} : Target to introspect.
	#   ${2} : Key to use for introspection.
	# Return:
	#   0  : (normal).
	#   1+ : ERROR.

	# Set up working set
	report_telemetry "${FUNCNAME[0]}()"
	report_debug "${FUNCNAME[0]}(${*})"
	introspectTarget="${1}"
	shift
	key="${1}"
	shift
	# Core actions
	case ${key} in
		CANX )
			return
			;;
	esac
	case ${introspectTarget} in
		self )
			introspect_bash_pro_with_key "${key}"
			;;
		libsourcery )
			introspect_libsourcery_with_key "${key}"
			;;
		* )
			if [[ -n "${introspectTarget}" ]] ; then
				exit_error "Unknown introspect target: ${introspectTarget}" 3
			fi
			;;
	esac
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


introspect_bash_pro_with_key () {
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
		main )
			linesAfter="${bashProIntrospect[main]}"
			;;
		manual )
			linesAfter="${bashProIntrospect[manual]}"
			;;
		sourcery )
			linesAfter="${bashProIntrospect[sourcery]}"
			;;
		version )
			linesAfter="${bashProIntrospect[version]}"
			;;
		func_vers )
			linesAfter="${bashProIntrospect[func_vers]}"
			;;
	esac
	introspect_self "bash_pro-${key}" "${linesAfter}"
	report_debug "${FUNCNAME[1]}() <-- ${FUNCNAME[0]}()"
}


# Developer Note: This script supports running as a script like normal and sourcing as a library.
# 1. Change the below variable name to a unique ID for this script.
#    - Recommendation: Change "_THIS_" to the name of this script
#    - E.g. ${source__THIS__as_library} --> ${source_bash_pro_shop_as_library}
# 2. Assign a value to the uniquely named variable in the script you want to source this library from.
#    - E.g. source_bash_pro_shop_as_library=y
# 3. Source this script in the other script referencing this script as a library
#    - E.g. source bash_pro_shop.sh
# NOTE: bash does not have the concept of namespaces, name collisions will overwrite previous assignments when sourced.
if [[ -z "${source_bash_pro_shop_as_library}" ]] ; then
	main "${@}"
fi
