#!/usr/bin/env bash

# Description: Script to select a random but repeatable set of elements from a list of elements

# Algorithm:
# - Calculate the hash of each element; i.e. use the hash algorithm to provide random ordering
# - Sort the hashes
# - Output the desired number of sorted hashes as elements to select

# Dependencies:
# /bin/cat
# /bin/echo
# /bin/rm
# /usr/bin/openssl
# /usr/bin/sort

# main function
case ${#} in
	2 )
		;;
	* )
		/bin/echo selectElems.sh "<Elements Input File> <Number of Elements>"
		exit 1
		;;
esac

# Calcucate hashes
/bin/echo -n "" > .selectElems.hash
for elemID in $( /bin/cat ${1} ) ; do
	/bin/echo ${elemID} > .select${elemID}
	/usr/bin/openssl dgst -md5 .select${elemID} >> .selectElems.hash
	/bin/rm -f .select${elemID}
done

# Sort hashes
/usr/bin/sort -t " " -k 2 .selectElems.hash > .selectElems.sort

# Output list of selected transcripts
/usr/bin/head -n ${2} .selectElems.sort

# Clean up
/bin/rm -f .selectElems.hash
/bin/rm -f .selectElems.sort
