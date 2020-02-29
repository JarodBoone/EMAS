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
# 1 --> Active check? 
function check_work_directory() {

    if [ $# -ne 1 ]; then 
        print_error "Internal Error: incorrect number of arguments to check_work_directory"
        exit_EMAS
    fi

    __ACTIVE=$1

    # Check to see if the work directory exists, if it does not make one 
    if [ ! -d "${WORK_DIRECTORY}" ]; then 
        print_warning "No work directory found."
        if [ $1 = $ACTIVE ]; then 
            
            if ask "Would you like to create a work directory at ${COLOR_GRAY}${WORK_DIRECTORY}${COLOR_NONE}?"; then
                mkdir -p "${WORK_DIRECTORY}"
                print_success "Created work directory at ${COLOR_GRAY}${WORK_DIRECTORY}${COLOR_NONE}"
            else 
                return $FAIL
            fi        
        else 
            return $FAIL
        fi 
    else 
        print_message "Found work directory at ${COLOR_GRAY}${WORK_DIRECTORY}${COLOR_NONE}"
    fi

    # Check to see if the work directory exists, if it does not make one 
    if [ ! -d "${DISK_IMG_DIRECTORY}" ]; then 
        print_warning "No disk image work directory found."
        if [ $1 = $ACTIVE ]; then 
            
            if ask "Would you like to create a disk image work directory at ${DISK_IMG_DIRECTORY}?"; then
                mkdir -p "${DISK_IMG_DIRECTORY}"
                print_success "Created work directory at ${COLOR_GRAY}${DISK_IMG_DIRECTORY}${COLOR_NONE}"
            else 
                return $FAIL
            fi        
        else 
            return $FAIL
        fi 
    else 
        print_message "Found disk-image work directory at ${COLOR_GRAY}${DISK_IMG_DIRECTORY}${COLOR_NONE}"
    fi

    # Check to see if the work directory exists, if it does not make one 
    if [ ! -d "${SCENARIO_OUTPUT_DIRECTORY}" ]; then 
        print_warning "No scenario work directory found."
        if [ $1 = $ACTIVE ]; then 
            
            if ask "Would you like to create a scenario work directory at ${COLOR_GRAY}${SCENARIO_OUTPUT_DIRECTORY}${COLOR_NONE}?"; then
                mkdir -p "${SCENARIO_OUTPUT_DIRECTORY}"
                print_success "Created work directory at ${COLOR_GRAY}${SCENARIO_OUTPUT_DIRECTORY}${COLOR_NONE}"
            else 
                return $FAIL
            fi        
        else 
            return $FAIL
        fi 
    else 
        print_message "Found scenario work directory at ${COLOR_GRAY}${SCENARIO_OUTPUT_DIRECTORY}${COLOR_NONE}"
    fi

    return $SUCCESS

}

# Make sure that the target scenario has a work directory 
# 1 --> Active check 
function check_target_family_work_directory() { 
    if ! scenario_targeted; then 
        print_error "No scenario targeted"
        return $FAIL
    fi 

    if [[ ! -d "${TARGET_FAMILY_WORK_DIR}" ]]; then 
        print_warning "No Scenario work directory found."
        
        if [ $1 = $ACTIVE ]; then 
            if ask "Would you like to create one at ${TARGET_FAMILY_WORK_DIR}?"; then
                mkdir -p "${TARGET_FAMILY_WORK_DIR}"
                print_ok "Created scenario work directory at ${TARGET_FAMILY_WORK_DIR}"
                return $SUCCESS
            else 
                print_warning "You cannot run this scenario family (${TARGET_SCENARIO_FAMILY}) without a work directory"
                return $FAIL
            fi   
        fi 

        return $FAIL
    fi
    
    return $SUCCESS
}

# Make sure that the target scenario has a work directory 
# 1 --> Active check 
function check_target_instance_work_directory() { 
    if ! scenario_targeted; then 
        print_error "No scenario targeted"
        return $FAIL
    fi 

    if [[ ! -d "${TARGET_INSTANCE_WORK_DIR}" ]]; then 
        print_warning "No Scenario work directory found."
        
        if [ $1 = $ACTIVE ]; then 
            if ask "Would you like to create one at ${TARGET_INSTANCE_WORK_DIR}?"; then
                mkdir -p "${TARGET_INSTANCE_WORK_DIR}"
                print_ok "Created scenario work directory at ${TARGET_INSTANCE_WORK_DIR}"
                return $SUCCESS
            else 
                print_warning "You cannot run this scenario (${TARGET_SCENARIO_FAMILY}.${TARGET_SCENARIO_INSTANCE}) without a work directory"
                return $FAIL
            fi   
        fi 

        return $FAIL
    fi
    
    return $SUCCESS
}

#############################################################################################
#################################### DISK_IMAGE #############################################
#############################################################################################

# Create an empty disk image with the 
# 1 --> The absolute path of the disk image to be created 
# 2 --> The size of the disk image 
function create_disk_image() { 
    if [ $# -ne 2 ]; then 
        print_error "Internal Error: incorrect number of arguments to create_disk_image"
        exit_EMAS
    fi

    if [ -e $1 ]; then
        print_warning "Specified disk image \"${1}\" already exists"

        if ask "Are you sure you would like to delete ${1} and recreate it?"; then
            print_status "Deleting ${1}"
            rm -rf $1
        else 
            return $FAIL
        fi   
    fi 

    # Create an empty disk image
    dd if=/dev/zero of=$1 count=$2 

    # __LOOP_DEV=$(sudo losetup -f)
    # sudo losetup $__LOOP_DEV $1
    echo ';' | sudo sfdisk --no-reread $1
    # fsync 
    # sfdisk -l 

    # sudo losetup -d $__LOOP_DEV 

}

# Format a disk image with a filesystem 
# 1 --> The name of the disk image to format
function format_disk_image() { 
    if [ $# -ne 1 ]; then 
        print_error "Internal Error: incorrect number of arguments to format_disk_image"
        exit_EMAS
    fi

    

    # Mount the directory 
    __LOOP_DEV=$(sudo losetup -f)
    print_message "loop device ${__LOOP_DEV} targeted"

    mkdir $GEM5_TEMP_MNT_DIRECTORY

    $GEM5_DISK_UTIL mount $1 $GEM5_TEMP_MNT_DIRECTORY

    pushd $GEM5_TEMP_MNT_DIRECTORY > /dev/null

    ls 

    mkdir "fuck"

    popd > /dev/null

    $GEM5_DISK_UTIL unmount $GEM5_TEMP_MNT_DIRECTORY

    # rm -rf $GEM5_TEMP_MNT_DIRECTORY

}

# Make sure that the disk image specified by the targeted scenario
function check_target_disk_image() { 
    if ! check_variable $GEM5_DISK_IMG "GEM5_DISK_IMG"; then 
        print_error "No disk image specified"
        return $FAIL
    fi 

    if ! [ -e $GEM5_DISK_IMG ]; then
        print_warning "Specified disk image \"${GEM5_DISK_IMG}\" does not exist"

        if [ $1 = $ACTIVE ]; then 
            if ask "Would you like to create one at ${GEM5_DISK_IMG}?"; then
                # $GEM5_DISK_UTIL init ${GEM5_DISK_IMG} ${GEM5_DISK_IMG_SIZE}
                # print_ok "Created empty disk image at ${GEM5_DISK_IMG}"
                
                # format_disk_image $GEM5_DISK_IMG
                # print_ok "Formatted ${GEM5_DISK_IMG}"

                create_disk_image $GEM5_DISK_IMG $GEM5_DISK_IMG_SIZE

            else 
                print_warning "Specified disk image \"${GEM5_DISK_IMG}\" not present"
                return $FAIL
            fi   
        fi 

    fi 

    # DELETE ME 
    # rm -rf $GEM5_DISK_IMG
    # format_disk_image $GEM5_DISK_IMG
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

    # Check to see if the scenario directory exists
    if [ ! -d "${SCENARIO_DIRECTORY}" ]; then 
        
        print_warning "No scenario directory found."
        if [ $1 = $ACTIVE ]; then 
            if ask "Would you like to create a scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}?"; then
                mkdir -p "${SCENARIO_DIRECTORY}"
                print_success "Created scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}"
            else
                return $FAIL
            fi      
        else 
            return $FAIL
        fi 
    else 
        print_message "Found scenario directory at ${COLOR_GRAY}${SCENARIO_DIRECTORY}${COLOR_NONE}"
    fi 

    # Make sure each directory has its own build script 
    for scenario_family in "${SCENARIO_FAMILIES[@]}"; do 
        pushd "${SCENARIO_DIRECTORY}/${scenario_family}" > /dev/null

        if [ ! -f "build" ]; then 
            print_warning "No build script for scenario family ${COLOR_PURPLE}${scenario_family}${COLOR_NONE}"

            if [ $1 = $ACTIVE ]; then 
                if ask "Would you like to initialize ${scenario_family} with the default build script?"; then
                    print_message "... Adding default build script to $PWD"
                    cp "../build.default" . 
                    print_success "Added build script to scenario family ${COLOR_PURPLE}${scenario_family}${COLOR_NONE}"
                else 
                    return $FAIL
                fi 
            else 
                return $FAIL
            fi 
        fi 

        popd > /dev/null
    done 

    return $SUCCESS
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
    if [ $__EMAS_IS_CONFIGURED = $FALSE ]; then 
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

    if [ ! -f "${STATE_FILE_DEFAULT}" ]; then 
        print_error "No default state file found. Expeted ${STATE_FILE_DEFAULT} to exist!"
        print_message "Consider re cloning or downloading the repository"
        exit_EMAS
        
    fi 

    if [ ! -f "${STATE_FILE}" ]; then 
        print_warning "EMAS could not find a state file"
        print_status "Creating default state file at ${STATE_FILE}"
        cat "${STATE_FILE_DEFAULT}" > "${STATE_FILE}"
        lock_state
    fi 

    source "${STATE_FILE}"

    # Check that EMAS is in the configured state. If not offer configuration 
    if [ $__EMAS_IS_CONFIGURED = $FALSE ]; then 
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
        print_ok "${__VAR_NAME} set to ${__VAR_VALUE}"
    fi
}
