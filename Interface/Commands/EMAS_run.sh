#!/bin/bash 
function EMAS_run() {
    print_status "Executing ${COLOR_PURPLE}run${COLOR_NONE} Command"
    # Lets build 
    print_message "... Running Gem5"

    # Read the scenario 
    REQUIRED_ARGNUM=0

    if (($# < 1)) ; then 
        print_warning "Task ${COLOR_PURPLE}run${COLOR_NONE} not given scenario argument"
        print_status "Running previously targeted scenario ${__CURRENT_SCENARIO}"
        exit_EMAS
    fi

    # we have at least one argument 
    SCENARIO_NAME_RAW=$1
    SAVEIFS=$IFS

    # Parse argument into scenario family and id 
    IFS="."
    read -r -a array <<< "$SCENARIO_NAME_RAW"
    IFS=$SAVEIFS

    REQUIRED_SCENARIO_COMPONENTS=2
    if (($REQUIRED_SCENARIO_COMPONENTS != ${#array[@]})); then 
        printf "nah"
    fi 

    export INPUT_FAMILY=${SCENARIO_FAMILIES[${array[0]}]}
    export INPUT_INSTANCE=${array[1]} 

    print_message "... Looking for scenario [${INPUT_FAMILY}:${INPUT_INSTANCE}]"

    # Check if the scenario exists 

    pushd $SCENARIO_DIRECTORY/$INPUT_FAMILY > /dev/null

    source "build"

    __INSTANCE_COUNT=0
    SCENARIOS_IN_FAMILY=($(ls | sed 's:/$::'))

    for scenario in "${SCENARIOS_IN_FAMILY[@]}"; do 
        if [ "${scenario}" != "build" ]; then 
            if [ "${scenario}" == "${INPUT_INSTANCE}" ] || [ "${__INSTANCE_COUNT}" == "${INPUT_INSTANCE}" ]; then 
                # Found the instance to build 
                print_ok "Found instance ${scenario}"

                print_message "... Loading instance ${scenario} specific build options"

                source "${scenario}"

                pushd $GEM5_DIRECTORY > /dev/null

                check_variable $GEM5_SIM_PLATFORM "GEM5_SIM_PLATFORM"
                check_variable $GEM5_SIM_MODE "GEM5_SdIM_MODE"

                printf "\n"
                print_status "Running Gem5 build script"

                # Make sure the proper bariables are defined 
                scons "${WORK_DIRECTORY}/build/${GEM5_SIM_PLATFORM}/gem5.${GEM5_SIM_MODE}" --colors -j9

                printf "\n"

                update_state __CURRENT_SCENARIO "${INPUT_FAMILY}.${INPUT_INSTANCE}"

                popd > /dev/null 

                exit_EMAS
            fi

            __INSTANCE_COUNT=$((__INSTANCE_COUNT + 1))
        fi 

    done 

    popd > /dev/null

    # Actually build gem5 

    
}