#!/bin/bash 
# This script acts as an entrypoint to the EMAS system. All functionality should be accessed through 
# this script. 
# Author - Jarod Boone 

# Treat unset variables as errors when substituting 
set -u 

# Stop script execution after we receive an error 
set -e 

# Get the configuration variables (directory locations)
source "./config"

# Get common utilities 
source "${INTERFACE_DIRECTORY}/common.sh" # scenario setup utilities 
source "${INTERFACE_DIRECTORY}/print.sh" # printing utilites 
source "${INTERFACE_DIRECTORY}/setup.sh" # simulation setup utilities 
source "${INTERFACE_DIRECTORY}/scenarios.sh" # scenario setup utilities 

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


# If there are no arguments given to EMAS then fail
if [ $# -eq 0 ]; then
    print_error "No arguments given to EMAS"
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

exit_EMAS