#!/bin/bash 
# This script acts as an entrypoint to the EMAS system. All functionality should be accessed through 
# this script. 
# Author - Jarod Boone 

# Treat unset variables as errors when substituting 
set -u 

# Stop script execution after we receive an error 
set -e 

# Change directories to the location of this script 
pushd "$(dirname "$0")" > /dev/null 

# Get the configuration variables (directory locations) and state varibles
# (reflections of EMAS state)
source "./config"

# check for output control flags 
export __DEBUG=0
export __VERBOSE=0

__COUNT=1
for var in "$@"; do
    if [ "$var" == "--debug" ] || [ "$var" == "-dbg" ]; then 
        set -- "${@:1:$((__COUNT - 1))}" "${@:$((__COUNT + 1)):8}"
        __DEBUG=1
        __VERBOSE=1
    fi 

    if [ "$var" == "--verbose" ] || [ "$var" == "-v" ]; then 
        set -- "${@:1:$((__COUNT - 1))}" "${@:$((__COUNT + 1)):8}"
        __VERBOSE=1
    fi 

    __COUNT=$((__COUNT + 1))
done


# Get common utilities 
source "${INTERFACE_DIRECTORY}/print.sh" # printing utilites 
source "${INTERFACE_DIRECTORY}/common.sh" # common interface utilities 
source "${INTERFACE_DIRECTORY}/scenarios.sh" # scenario setup utilities 
source "${INTERFACE_DIRECTORY}/setup.sh" # simulation setup utilities 

#TODO: Make an EMAS_commands array and use that to source all the command scripts and 
# check if a command is valid 

# Get EMAS command functions 
for cmd_file in  $INTERFACE_DIRECTORY/Commands/* ; do 
    source $cmd_file
done 

#############################################################################################
#################################### EMAS ###################################################
#############################################################################################

# Hello! 
print_welcome

# Check that we are configured at all and load state variables 
check_config

# If there are no arguments given to EMAS then fail
if [ $# -eq 0 ]; then
    print_error "No commands given to EMAS"
    prompt_help
    exit_EMAS
fi

# Take the lowercase version of the first bash argument as the EMAS command
export RAW_CMD=$1
export EMAS_CMD="${RAW_CMD,,}"

print_message "Task Requested: ${COLOR_PURPLE}${EMAS_CMD}${COLOR_NONE}"

if ! type EMAS_$EMAS_CMD &> /dev/null ; then 
    print_error "Unrecognized task: \"${EMAS_CMD}\""
    prompt_help
    exit_EMAS
fi

# Shift the arguments
shift 1

# Execute the command 
EMAS_$EMAS_CMD $@

# Return to the previous working directory 
popd > /dev/null 

exit_EMAS