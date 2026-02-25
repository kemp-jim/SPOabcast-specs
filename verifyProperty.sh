#!/bin/bash

# This script creates the .pbesfile and then verifies the formula (in .mcf format) provided as the second argument.
# The first argument is the .lts file.
# Evidence of the formula is generated and the files are stored in a new directory.

# Name of the pbes file that is created
PBESFILE="pbesfile.pbes"


# Default flag for lts2pbes
lts2pbesflags="-c -v -p"


# Exit if no lts is provided
if [[ -z "$1" ]]; then
	echo ""
	echo "------------------------------------"
	echo "No .lts provided...exiting"
	echo "------------------------------------"
	echo ""
	exit -1
fi

# If the .lts does not exist, then exit
if [ ! -f "$1" ]; then
	echo ""
	echo "------------------------------------"
	echo "$1 not found. Exiting.."
	echo "------------------------------------"
	echo ""
	exit -1
fi


# Exit if no formula is provided
if [[ -z "$2" ]]; then
	echo ""
	echo "------------------------------------"
	echo "No formula provided...exiting"
	echo "------------------------------------"
	echo ""
	exit -1
fi

# If the formula file does not exist, then exit
if [ ! -f "$2" ]; then
	echo ""
	echo "------------------------------------"
	echo "$2 not found. Exiting.."
	echo "------------------------------------"
	echo ""
	exit -1
fi



# Create a dir for the files

cdate="$(date '+%Y-%m-%d--%H-%M')"

fileName=$(basename "$2" .mcf)

dirname="$fileName"_"${cdate}"

echo "$dirname"

mkdir -p "$dirname"

cd "$dirname"


echo ""
echo "------------------------------------"
echo "Generating pbes"
echo "------------------------------------"
echo ""
lts2pbes $lts2pbesflags --formula=../"$2" ../$1 $PBESFILE

echo ""
echo "------------------------------------"
echo "Solving pbes"
echo "------------------------------------"
echo ""
pbessolve -v --file=../$1 $PBESFILE

