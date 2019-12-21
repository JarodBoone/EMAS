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

# Get printing utilities 
source "${UTIL_DIRECTORY}/print.sh"

#TODO: Make an EMAS_commands array and use that to source all the command scripts and 
# check if a command is valid 

# Get EMAS command functions 
source "${UTIL_DIRECTORY}/Commands/EMAS_build.sh" # build command 

print_welcome
print_message "$1 arguments supplied" # DEBUGGING 

if [ $# -eq 0 ]; then
    print_error "No arguments given to EMAS"
    prompt_help
fi

# Take the lowercase version of the first bash argument as the EMAS command
export RAW_CMD=$1
export EMAS_CMD="${RAW_CMD,,}"

EMAS_$EMAS_CMD

# Shift the arguments
shift 1