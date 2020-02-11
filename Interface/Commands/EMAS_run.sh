#!/bin/bash 
function EMAS_run() {
    # The run command is the main functionality of EMAS 
    # 1 -> Verify that the correct scenario is built 
    print_status "Executing ${COLOR_PURPLE}run${COLOR_NONE} Command"

    if [[ " ${__BUILD_DONE} " == " 0 " ]]; then 
        print_error "No scenario has been built. Build a scenario first with ${COLOR_PURPLE}EMAS.sh build ${COLOR_NONE}"
        exit_EMAS
    fi 

    # Lets build 
    print_message "... Running Gem5"

    # Read the scenario 
    REQUIRED_ARGNUM=0

    if (($# < 1)) ; then 
        print_warning "Task ${COLOR_PURPLE}run${COLOR_NONE} not given scenario argument"
        print_status "Running previously targeted scenario ${__CURRENT_SCENARIO}"
        if ! target_scenario $__CURRENT_SCENARIO; then
            exit_EMAS
        fi
    else 
        if ! target_scenario $1; then
            exit_EMAS
        fi
    fi

    # Check that we have a work directory 
    if ! check_target_scenario_work_directory $PASSIVE; then 
        print_error "Cannot run scenario without a work directory"
        exit_EMAS
    fi 

    # Make sure that the simulator is built for this family 
    if [[ ! " ${__BUILT_SCENARIO_FAMILY} " = " ${TARGET_SCENARIO_FAMILY} " ]]; then 
        print_error "Wrong binary built"
    fi 

    # run gem5 


    # Actually build gem5 

    
}