#!/bin/bash 
# Shell utilities used for managing and loading scenarios 

# Get an array of all the scenario directories available 
pushd "${SCENARIO_DIRECTORY}" > /dev/null
export SCENARIO_FAMILIES=($(ls -d */ | sed 's:/$::'))
popd > /dev/null

# List all the scenario names 
function list_scenarios() {
    printf " ${COLOR_PURPLE}Defined Scenarios${COLOR_NONE}: \n"

    __FAMILY_COUNT=0
    for scenario_family in "${SCENARIO_FAMILIES[@]}"; do 
        pushd "${SCENARIO_DIRECTORY}/${scenario_family}" > /dev/null

        line=$(head -n 1 build)
        line="${line:1}"
        line=$(echo "${line}" | awk '{$1=$1;print}')

        printf "\n ==> [Family ${COLOR_PURPLE}${scenario_family}${COLOR_NONE}] ($__FAMILY_COUNT): ${line}\n"
        
        SCENARIOS_IN_FAMILY=($(ls | sed 's:/$::'))

        __INSTANCE_COUNT=0
        for scenario in "${SCENARIOS_IN_FAMILY[@]}"; do 
            if [ "${scenario}" != "build" ]; then 
                printf "\t[Instance ${COLOR_YELLOW}${scenario}${COLOR_NONE}] ($__FAMILY_COUNT.$__INSTANCE_COUNT | $scenario_family.$__INSTANCE_COUNT) : \n"
                __INSTANCE_COUNT=$((__INSTANCE_COUNT + 1))
            fi 
            
        done 

        __FAMILY_COUNT=$((__FAMILY_COUNT + 1))
        popd > /dev/null
    done 
}

function scenario_exists() { 
    if [ $# -ne 2] ; then 
        print_error "Internal Error: incorrect number of arguments to scenario_exists"
        exit_EMAS
    fi
}

function get_scenario() {
    
}

# Create new scenario family 
# Create new secnario in family 