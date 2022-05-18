#!/usr/bin/env bash


# NAME
#	hostInfoGather.sh	Gather system and setting information for host.
#
# SYNOPSIS
#	hostInfoGather.sh help
#	hostInfoGather.sh <host_ID>
#
# DESCRIPTION
#	Gather system and setting information for host_ID.
#	Simple automation of common information gathering steps in support of testing.
#	Implementation does include (embed) expert knowledge of test environment, i.e. script is customized for given test environments.
#
#	See OS based routines.
#
#	Sub-Commands:
#	help	Display help message, supports single term filtering
#
# EXIT STATUS
#	0	(normal) On success.
#	1+	ERROR
#	2	ERROR: Invalid usage
#
# DEPENDENCIES
#	arp(1)       : ...
#	cat(1)       : ...
#	echo(0|1)    : Builtin or POSIX echo
#	egrep(1)     : POSIX egrep
#	grep(1)      : POSIX grep
#	ifconfig(1)  : [BSD, macOS] ...
#	less(1)      : GNU (common UNIX) less
#	nmcli(1)     : [Ubuntu] ...
#	ping(1)      : ...
#	ssh(1)       : ...
#	tee(1)       : ...
#	tr(1)        : POSIX tr
#	uname(1)     : ...


# Save script name
SELF="${0}"


main () {
	# Description: Main control flow

	# Set up working set
	subCmd="${1}"
	shift
	setUpEnv
	# Core actions
	case ${subCmd} in
		help )  # Display this help message, supports single term filtering
			searchTerm="${1}"
			usage "${searchTerm}"
			;;
		homeLab-target )   # Treat localhost as target type system in Home Lab environment
			gatherLocalInfo target
			;;
		homeLab-tester )   # Treat localhost as tester type system in Home Lab environment
			gatherLocalInfo tester
			;;
		homeLab-gateway )  # Retrieve information from Home Lab environment gateway system
			gatherGatewayInfo
			;;
		* )
			# Default: Blank or unknown subcommand, report error if unknown subcommand
			# Note: Lack of comment on same line as case, default action will not be displayed by usage
			usage
			if [[ -n ${subCmd} ]] ; then
				errorExit "ERROR: Unknown subcommand: ${subCmd}" 2
			fi
			;;
	esac
}


usage () {
	# Description: Generate and display usage
	# References: Albing, C., JP Vossen. bash Idioms. O'Reilly. 2022.

	(
		echo `basename ${SELF}` 'Usage:'
		egrep '\)[[:space:]]+# ' ${SELF} | tr -s '\t'
	) | grep "${1:-.}" | less
}


errorExit () {
	# Description: Output ${1} (error message) to stderr and exit with ${2} (error status).

	# Set up working set
	errorStatus=1
	errorMessage="${1}"
	# Core actions
	echo ${errorMessage} >&2
	if [[ -n ${2} ]] ; then
		errorStatus=${2}
	fi
	cleanUpArtifacts
	exit ${errorStatus}
}


warningReport () {
	# Description: Output ${1} (warning message) to stderr, but DO NOT exit.

	warningMessage="${1}"
	echo ${warningMessage} >&2
}


setUpEnv () {
	# Description: Set up environment

	if [[ -z ${TMPDIR} ]] ; then
		TMPDIR='/tmp/'
	fi
	# Host and LAN Specifics
	gatewayAddr='<gateway_address>'
	gatewayName='<gateway_hostname>'
	gatewayNICname='<gateway_NIC_name>'
	gatewayUsername='<gateway_username>'
	otherHostAddr='<other_host_address>'
	hostNICname='<host_NIC_name>'
}


gatherLocalInfo () {
	# Description: Gather localhost information, identified as ${1} (system classification name).
	# Arguments:
	#   ${1} : Term to classify/identify system as
	# Return:
	#  0  : (normal)
	#  1+ : ERROR

	# Set up working set
	hostType="${1}"
	shift
	# Core actions
	# gatherLocalInfoMacOS "${hostType}"
	# gatherLocalInfoUbuntu "${hostType}"
}


gatherLocalInfoMacOS () {
	# Description: Gather localhost information on macOS based host, identified as ${1} (system classification name).
	# Arguments:
	#   ${1} : Term to classify/identify system as
	# Return:
	#  0  : (normal)
	#  1+ : ERROR

	# Set up working set
	hostType="${1}"
	shift
	# Core actions
	uname -a                      | tee "${hostType}_system-uname-a.txt"
	ifconfig "${hostNICname}"     | tee "${hostType}_system-ifconfig-${hostNICname}.txt"
	cat /etc/hosts                | tee "${hostType}_system-etc_hosts.txt"
	ping -c 3 "${gatewayAddr}"
	ping -c 3 "${otherHostAddr}"
	arp -a -n -i "${hostNICname}" | tee "${hostType}_system-arp-a_n_i_${hostNICname}.txt"
}


gatherLocalInfoUbuntu () {
	# Description: Gather localhost information on macOS based host, identified as ${1} (system classification name).
	# Arguments:
	#   ${1} : Term to classify/identify system as
	# Return:
	#  0  : (normal)
	#  1+ : ERROR

	# Set up working set
	hostType="${1}"
	shift
	# Core actions
	uname -a                           | tee "${hostType}_system-uname-a.txt"
	nmcli device show "${hostNICname}" | tee "${hostType}_system-nmcli-device_show_${hostNICname}.txt"
	cat /etc/hosts                     | tee "${hostType}_system-etc_hosts.txt"
	ping -c 3 "${gatewayAddr}"
	ping -c 3 "${otherHostAddr}"
	arp -a -n -i "${hostNICname}"      | tee "${hostType}_system-arp-a_n_i_${hostNICname}.txt"
}


gatherGatewayInfo () {
	# Description: Gather gateway information.
	# Return:
	#  0  : (normal)
	#  1+ : ERROR

	# Set up working set
	:
	# Core actions
	# gatherGatewayInfoBSD
	# gatherGatewayInfoUbuntu
	# gatherGatewayInfoRaspberry
}


gatherGatewayInfoBSD () {
	# Description: Gather gateway information on BSD based host.
	# Arguments:
	#   (none)
	# Return:
	#  0  : (normal)
	#  1+ : ERROR

	# Set up working set
	:
	# Core actions
	ssh ${gatewayUsername}@${gatewayName} 'uname -a'                           | tee gateway_system-uname-a.txt
	ssh ${gatewayUsername}@${gatewayName} "ifconfig \"${gatewayNICname}\""     | tee "gateway_system-ifconfig-${gatewayNICname}.txt"
	ssh ${gatewayUsername}@${gatewayName} 'cat /etc/hosts'                     | tee gateway_system-etc_hosts.txt
	ssh ${gatewayUsername}@${gatewayName} "arp -a -n -i \"${gatewayNICname}\"" | tee "gateway_system-arp-a_n_i_${gatewayNICname}.txt"
}


cleanUpArtifacts () {
	# Description: Clean up artifacts from actions
	# Arguments:
	#   (none)
	# Return:
	#  0  : (normal)
	#  1+ : ERROR

	removeTempFiles
}


removeTempFiles () {
	# Description: Remove temporary files from filesystem
	# Arguments:
	#   (none)
	# Return:
	#   0  : (normal)
	#   1+ : ERROR

	:
}


main "${@}"
