#!/bin/bash 

####################################################################################################
############################## USER INTERACION #####################################################
####################################################################################################

# ask for yes or no before running a function
# 1 --> Prompt string 
function ask() { 
    if [ $# -ne 1 ]; then 
        print_error "Internal Error: incorrect number of arguments to ask"
        exit_EMAS
    fi  

    while true; do
        printf "${COLOR_VIOLET} \n [Input] <==${COLOR_NONE}"
        read -p " $1 [Y(es)/N(o)] : " yn
        printf "${COLOR_NONE}"
        case $yn in
            [Yy]* ) printf "\n"; return 0; break;;
            [Nn]* ) printf "\n"; return 1; break;;
            * ) printf " ${COLOR_VIOLET}please answer Y(es) or N(o)${COLOR_NONE}";;
        esac
    done    
}

# ask for yes or no before running a function
# 1 --> Prompt string 
# 2 --> Function to execute if yes 
# 3 --> Prompt if yes
# 4 --> Function to execute if no 
# 5 --> Prompt if no
function askf() { 
    if [ $# -ne 5 ]; then 
        print_error "Internal Error: incorrect number of arguments to askf"
        exit_EMAS
    fi  

    while true; do
        printf "${COLOR_VIOLET} \n [Input] <==${COLOR_NONE}"
        read -p " $1 [Y(es)/N(o)] : " yn
        printf "${COLOR_NONE}"
        case $yn in
            [Yy]* ) printf "\n"; print_message "$3"; $2; break;;
            [Nn]* ) printf "\n"; print_message "$5"; $4; break;;
            * ) printf " ${COLOR_VIOLET}please answer Y(es) or N(o)${COLOR_NONE}";;
        esac
    done    
}

####################################################################################################
############################# STATE MANAGEMENT #####################################################
####################################################################################################

function check_state_consistent() { 
    __ACTIVE=$1

    state_hash=$(sha1sum ${STATE_FILE})
    if [[ "${state_hash}" != "$(cat $STATE_FILE_LOCK)" ]]; then 
        print_error "EMAS state corrupted. Did you change ${STATE_FILE}?"
        if [ $__ACTIVE -eq "1" ]; then 
            
            # askf "Would you like to configure EMAS?" EMAS_config "You have chosen to configure EMAS" exit_EMAS "You have chosen not to configure EMAS :("
            if ask "Would you like to reconfigure EMAS?"; then
                EMAS_config
                print_success "Created scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}"
            else 
                return 1
            fi        
        else 
            return 1
        fi
    fi 
}

function lock_state() { 
    print_message "... Locking EMAS state to ${STATE_FILE_LOCK}"
    sha1sum $STATE_FILE > "${STATE_FILE_LOCK}"
}

function update_state() { 
    if grep -q "export $1=" $STATE_FILE; then
        print_message "... Updating state variable $1 to $2"
        val=$(echo "$2" | sed 's/\//\\\//g') # Escape back slashes if there are any
        sed -i "s/export ${1}=.*/export ${1}=${val}/g" "${STATE_FILE}"
        export $1=$2
        lock_state 
    else 
        print_error "Internal Error: state variable $1 does not exist"
        exit_EMAS
    fi 
}

####################################################################################################
############################# EXIT FUNCTION ########################################################
####################################################################################################

# Gracefully exit the simulator 
function exit_EMAS() { 
    print_goodbye
    printf "${COLOR_NONE}"
    exit
}

####################################################################################################
############################# UTIL #################################################################
####################################################################################################
# Return codes 
export SUCCESS=0
export FAIL=1

# Check function flags 
export TRUE=true
export FALSE=false

# Check function flags 
export ACTIVE=true
export PASSIVE=false

# Check if a given input is a number 
# 1 --> variable to check if it is a number
function is_number() {
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]]; then 
        return $FAIL
    else
        return $SUCCESS
    fi
}
