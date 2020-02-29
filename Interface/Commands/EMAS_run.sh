#!/bin/bash 
function EMAS_run() {
    # The run command is the main functionality of EMAS 
    # 1 -> Verify that the correct scenario is built 
    print_status "Executing ${COLOR_PURPLE}run${COLOR_NONE} Command"

    if [[ " ${__BUILD_DONE} " == " ${FALSE} " ]]; then 
        print_error "No scenario has been built. Build a scenario first with ${COLOR_PURPLE}EMAS.sh build ${COLOR_NONE}"
        exit_EMAS
    fi 

    # Lets build 
    print_message "... Running Gem5"

    # Read the scenario 
    REQUIRED_ARGNUM=0

    if (($# < 1)) ; then 
        print_warning "Task ${COLOR_PURPLE}run${COLOR_NONE} not given scenario argument"
        print_status "Running previously built scenario family ${__BUILT_SCENARIO_FAMILY}"
        print_status "Defaulting to instance 0 of scenario family ${__BUILT_SCENARIO_FAMILY}"
        __TARGET_ME="${__BUILT_SCENARIO_FAMILY}.0"
        if ! target_scenario_instance $__TARGET_ME; then
            exit_EMAS
        fi
    else 
        if ! target_scenario_instance $1; then
            exit_EMAS
        fi
    fi

    # Check that we have a work directory 
    if ! check_target_instance_work_directory $ACTIVE; then 
        print_error "Cannot run scenario without a work directory"
        exit_EMAS
    fi 

    # Make sure that the simulator is built for this family 
    if [[ ! " ${__BUILT_SCENARIO_FAMILY} " = " ${TARGET_SCENARIO_FAMILY} " ]]; then 
        print_error "Current GEM5 binary was built for scenario family \"${__BUILT_SCENARIO_FAMILY}\", not \"${TARGET_SCENARIO_FAMILY}\""
        print_message "Use ${COLOR_PURPLE}EMAS.sh build ${TARGET_SCENARIO_FAMILY} ${COLOR_NONE}to compile this scenario family"
    fi 

    # Load scenario instance variables 
    source "${TARGET_INSTANCE_SCRIPT}"

    # Disk image 
    check_variable $FS_SIMULATION "FS_SIMULATION"
    if [[ $FS_SIMULATION ]]; then 
        check_variable $GEM5_DISK_IMG "GEM5_DISK_IMG"
    fi 

    if ! check_target_disk_image $ACTIVE; then 
        print_error "Cannot run scenario without a properly formatted disk image"
    fi
    
    # Create run script 

    # run gem5 


    # Actually build gem5 

    
}