#!/bin/bash

# This targets a scenario family
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

    print_message "... Targeting scenario family"

    # Target the scenario family from input
    if ! target_scenario_family $1; then
        exit_EMAS
    fi
    
    # Load scenario family build options 
    source $TARGET_SCENARIO_BUILD

    # Verify that we have defined the variables needed to build 
    check_variable $GEM5_SIM_PLATFORM "GEM5_SIM_PLATFORM"
    check_variable $GEM5_SIM_MODE "GEM5_SIM_MODE"

    # Check if a work directory exists for this family 
    if ! check_target_family_work_directory $ACTIVE; then 
        print_error "Cannot build scenario family simulator without a work directory"
        exit_EMAS
    fi 

    # Compile gem5 
    print_status "Compiling gem5 binary for scenario family \"${TARGET_SCENARIO_FAMILY}\""
    
    pushd "${GEM5_DIRECTORY}" > /dev/null
    scons "${WORK_DIRECTORY}/build/${GEM5_SIM_PLATFORM}/gem5.${GEM5_SIM_MODE}" --colors -j9
    popd > /dev/null 

    printf "\n"
    print_success "Compiled simulator for scenario family \"${TARGET_SCENARIO_FAMILY}\" ${COLOR_GRAY}(${WORK_DIRECTORY}/build/${GEM5_SIM_PLATFORM}/gem5.${GEM5_SIM_MODE})${COLOR_NONE}"
    
    # Update EMAS state to reflect the fact that we just built the scenario family 
    update_state __BUILD_DONE $TRUE
    update_state __BUILT_SCENARIO_FAMILY "${TARGET_SCENARIO_FAMILY}"
    update_state __COMPILED_GEM5_BINARY "${WORK_DIRECTORY}/build/${GEM5_SIM_PLATFORM}/gem5.${GEM5_SIM_MODE}"

    exit_EMAS
}