#!/bin/bash 
# Various shell scripts to verify and setup and shutdown of simulation runtime 

# Trap on SIGINT to always get a clean exit 
trap sigint_handler INT; function sigint_handler() {
        printf "\n"
        print_message "Recived SIGINT ... Exiting"
        exit_EMAS
}

#############################################################################################
#################################### WORK DIR ###############################################
#############################################################################################

# Make sure that there is a work directory 
function check_work_directory() {

     if [ $# -ne 1 ]; then 
        print_error "Internal Error: incorrect number of arguments to check_work_directory"
        exit_EMAS
    fi

    __ACTIVE=$1

    # Check to see if the work directory exists, if it does not make one 
    if [ ! -d "${WORK_DIRECTORY}" ]; then 
        print_warning "No work directory found."
        if [ $__ACTIVE -eq "1" ]; then 
            
            if ask "Would you like to create a work directory at ${COLOR_GRAY}${WORK_DIRECTORY}${COLOR_NONE}?"; then
                mkdir -p "${WORK_DIRECTORY}"
                print_success "Created scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}"
            else 
                return 1
            fi        
        else 
            return 1
        fi 
    else 
        print_message "Found work directory at ${COLOR_GRAY}${WORK_DIRECTORY}${COLOR_NONE}"
    fi

}

#############################################################################################
#################################### SCENARIO DIR ###########################################
#############################################################################################

# Returns true if scenario directory is properly configured 
# 1 --> (1) active check (0) passive check 
function check_scenario_directory() {

    if [ $# -ne 1 ]; then 
        print_error "Internal Error: incorrect number of arguments to check_scenario_directory"
        exit_EMAS
    fi

    __ACTIVE=$1

    # Check to see if the scenario directory exists
    if [ ! -d "${SCENARIO_DIRECTORY}" ]; then 
        
        print_warning "No scenario directory found."
        if [ $__ACTIVE -eq "1" ]; then 
            
            if ask "Would you like to create a scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}?"; then
                mkdir -p "${SCENARIO_DIRECTORY}"
                print_success "Created scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}"
            else 
                return 1
            fi
                    
        else 
            return 1
        fi 
    else 
        print_message "Found scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}"
    fi 

    # Make sure each directory has its own build script 
    for scenario_family in "${SCENARIO_FAMILIES[@]}"; do 
        pushd "${SCENARIO_DIRECTORY}/${scenario_family}" > /dev/null

        if [ ! -f "build" ]; then 
            print_warning "No build script for scenario family ${COLOR_PURPLE}${scenario_family}${COLOR_NONE}"

            if [ $__ACTIVE -eq "1" ]; then 
                if ask "Would you like to initialize ${scenario_family} with the default build script?"; then
                    print_message "... Adding default build script to $PWD"
                    cp "../build" . 
                    print_success "Added build script to scenario family ${COLOR_PURPLE}${scenario_family}${COLOR_NONE}"
                else 
                    return 1
                fi 
            else 
                return 1
            fi 
        fi 

        popd > /dev/null
    done 

    return 0
}

#############################################################################################
#################################### CONFIG #################################################
#############################################################################################

# Go through and make sure everything is ok 
function verify_config() { 

    # State consistency 
    if ! check_state_consistent 1; then 
        exit_EMAS
    else 
        print_ok "EMAS state is consistent"
    fi 

    print_message "... Verifying that EMAS is properly configured"

    # Redundant check 
    if [ $__EMAS_IS_CONFIGURED -eq 0 ]; then 
        print_error "EMAS not configured!"
        return 1
    fi 

    if ! check_work_directory 0; then 
        print_warning "Work directory not configured properly!"
        print_message "EMAS is expecting the directory ${WORK_DIRECTORY} to exist"
        return 1
    else 
        print_ok "Work directory ${COLOR_GRAY}${WORK_DIRECTORY}${COLOR_NONE} properly configured"
    fi

    if ! check_scenario_directory 0; then 
        print_warning "Scenario directory not configured properly!"
        print_message "EMAS is expecting the directory ${SCENARIO_DIRECTORY} to exist and contain valid scenario directories"
        return 1
    else 
        print_ok "Scenario directory ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE} properly configured"
    fi

    return 0
}

# Check Configuration state and prompt configuration if necessary 
function check_config() { 

    # Check that EMAS is in the configured state. If not offer configuration 
    if [ $__EMAS_IS_CONFIGURED -eq 0 ]; then 
        print_error "It appears that EMAS is not configured on this machine"
        askf "Would you like to configure EMAS?" EMAS_config "You have chosen to configure EMAS" exit_EMAS "You have chosen not to configure EMAS :("
    fi 

    # Verify that we are configured correctly. If not offer configuration
    if verify_config; then 
         print_ok "EMAS is properly configured!\n"
    else 
        print_error "It appears that EMAS is not configured properly on this machine"
        askf "Would you like to configure EMAS?" EMAS_config "You have chosen to configure EMAS" exit_EMAS "You have chosen not to configure EMAS :("
    fi 
}

#############################################################################################
#################################### VALIDATION #############################################
#############################################################################################

# Check if a given bash variable is defined and exit EMAS if not 
# 1 --> variable value 
# 2 --> variable name 
function check_variable() { 
    __VAR_VALUE=$1
    __VAR_NAME=$2

    if [ -z ${__VAR_VALUE+x} ]; then 
        print_error "Build Error: ${__VAR_NAME} is not set"
        exit_EMAS
    else 
        print_ok "${__VAR_NAME} set to ${GEM5_SIM_PLATFORM}"
    fi
}
