#!/bin/bash 
function EMAS_run() {
    # The run command is the main functionality of EMAS 
    # 1 -> Verify that the correct scenario is built 
    print_status "Executing ${COLOR_PURPLE}run${COLOR_NONE} Command"
    # Lets build 
    print_message "... Running Gem5"

    # Read the scenario 
    REQUIRED_ARGNUM=0

    if (($# < 1)) ; then 
        print_warning "Task ${COLOR_PURPLE}run${COLOR_NONE} not given scenario argument"
        print_status "Running previously targeted scenario ${__CURRENT_SCENARIO}"
        __TARGET_SCENARIO=$__CURRENT_SCENARIO
    else 
        __TARGET_SCENARIO=$1

    fi

    # Parse the scenario
    SAVEIFS=$IFS

    # Parse argument into scenario family and id 
    IFS="."
    read -r -a array <<< "$__TARGET_SCENARIO"
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

    source $INPUT_INSTANCE

    popd > /dev/null

    # Need to make scenario directory or check that the scenario is set up 


    # Actually build gem5 

    
}