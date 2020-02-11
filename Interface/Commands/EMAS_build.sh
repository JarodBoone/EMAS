#!/bin/bash

function EMAS_build() {
    print_status "Executing Build Command"
    # Lets build 
    print_message "... Preparing to compile Gem5"

    # Read the scenario 
    REQUIRED_ARGNUM=1

    if (($# < $REQUIRED_ARGNUM)) ; then 
        print_error "Task ${COLOR_PURPLE}build${COLOR_NONE} requires scenario argument"
        prompt_help
        exit_EMAS
    fi

    print_message "... Targeting scenario"

    if ! target_scenario $1; then
        exit_EMAS
    fi
    
    source $TARGET_SCENARIO_BUILD

    check_variable $GEM5_SIM_PLATFORM "GEM5_SIM_PLATFORM"
    check_variable $GEM5_SIM_MODE "GEM5_SIM_MODE"

    if ! check_target_scenario_work_directory $ACTIVE; then 
        print_error "Cannot build without a work directory"
        exit_EMAS
    fi 

    print_status "Compiling gem5 binary for scenario ${TARGET_SCENARIO_FAMILY}.${TARGET_SCENARIO_INSTANCE}"
    
    pushd "${GEM5_DIRECTORY}" > /dev/null
    scons "${WORK_DIRECTORY}/build/${GEM5_SIM_PLATFORM}/gem5.${GEM5_SIM_MODE}" --colors -j9
    popd > /dev/null 

    printf "\n"
    print_success "Compiled simulator for scenario ${TARGET_SCENARIO_FAMILY}.${TARGET_SCENARIO_INSTANCE} ${COLOR_GRAY}(${WORK_DIRECTORY}/build/${GEM5_SIM_PLATFORM}/gem5.${GEM5_SIM_MODE})${COLOR_NONE}"
    
    update_state __BUILD_DONE $TRUE
    update_state __BUILT_SCENARIO_FAMILY "${TARGET_SCENARIO_FAMILY}"
    update_state __COMPILED_GEM5_BINARY "${WORK_DIRECTORY}/build/${GEM5_SIM_PLATFORM}/gem5.${GEM5_SIM_MODE}"

    exit_EMAS
}