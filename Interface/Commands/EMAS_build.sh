#!/bin/bash

function EMAS_build() {
    # Lets build 
    print_message "... Building Gem5"
    setup_work_directory

    # Read the scenario 
    REQUIRED_ARGNUM=1

    if (($# < $REQUIRED_ARGNUM)) ; then 
        print_error "Task ${COLOR_PURPLE}build${COLOR_NONE} requires scenario argument"
        prompt_help
        exit_EMAS
    fi

    # we have at least one argument 
    SCENARIO_NAME_RAW=$1
    echo "the raw ${SCENARIO_NAME_RAW}"
    SAVEIFS=$IFS
    IFS="."
    read -r -a array <<< "$SCENARIO_NAME_RAW"

    REQUIRED_SCENARIO_COMPONENTS=2
    if (($REQUIRED_SCENARIO_COMPONENTS != ${#array[@]})); then 
        printf "nah"
    fi 
    
    for element in "${array[@]}"; do 
        echo $element
    done 

    pushd $SCENARIO_DIRECTORY/$FAMILY_NAME/$SCENARIO_NUMBER

    # list_scenarios
}