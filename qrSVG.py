#!/usr/bin/env python3

"""
Description: Generate QR code of argv[1] into SVG.
Arguments:
	argv[1] : (Required) String to generate QR code of.
	argv[2] : (Required) Path/basename of SVG file to generate.
Return:
	0  : (normal).
	1+ : ERROR.
"""

import sys  # System Module: argv[], exit()
import pyqrcode  # QR Code Module: create(), qrObj.svg()

def main(
		cmdArgv=None
	) :
	"""
	Description: Main control flow of program.
	Arguments:
		cmdArgv : Command line arguments, expect same format as sys.argv
	Return:
		None  : (normal)
		1+ : ERROR, via sys.exit()
	"""
	# Setup environment
	if cmdArgv is None :
		argv = sys.argv[:]
	else :
		argv = cmdArgv
	# Validate environment
	if len(argv) != 3 :
		sys.exit(1)
	# Core Functionality
	qrObj = pyqrcode.create(argv[1])
	qrObj.svg(argv[2]+".svg", scale=4)

if __name__ == "__main__" :
	main()
