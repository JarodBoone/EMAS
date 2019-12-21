#!/bin/bash 
# Various printing utilities for shell scripts 

# Color printing variables. In order to print a color print with 
# printf "${COLOR} message ${COLOR_NONE}\n"
export COLOR_BOLD="\033[1m"
export COLOR_UNDERLINED="\033[4m"
export COLOR_GRAY="\033[0;37m"
export COLOR_RED="\033[1;31m"
export COLOR_GREEN="\033[1;32m"
export COLOR_YELLOW="\033[1;33m"
export COLOR_CYAN="\033[1;36m"
export COLOR_BLUE="\e[0;34m"
export COLOR_BBLUE="\e[1;34m"
export COLOR_VIOLET="\033[1;35m"
export COLOR_NONE="\033[0m"
export COLOR_PURPLE="\033[1;34m"
export SEPARATOR_LINE="********************************************************************************"
export NEWLINE="\n"

# Welcome to EMAS! 
function print_welcome() { 
    printf "\n${SEPARATOR_LINE} \n ${COLOR_GREEN} \t\t     Emerging Memory Architecture Simulator ${COLOR_NONE}\n${SEPARATOR_LINE} \n\n"
}

# Print an informational message 
# 1 --> messasge string 
function print_message() { 
    printf "${COLOR_GRAY} [Info] ${COLOR_NONE} ${1}\n"
}

# Print a success message 
# 1 --> messasge string 
function print_success() { 
    printf "${COLOR_GREEN} [Success] ${COLOR_NONE}${1}\n"
}

# Print a warning message 
# 1 --> messasge string 
function print_warning() { 
    printf "${COLOR_YELLOW} [Warning] ${COLOR_NONE}${1}\n"
}

# Print an error message 
# 1 --> messasge string 
function print_error() { 
    printf "${COLOR_RED} [Error] ${COLOR_NONE}${1}\n"
}

function prompt_help() {
    print_message "Use ${COLOR_PURPLE}./EMAS.sh -h ${COLOR_NONE}for help"
}