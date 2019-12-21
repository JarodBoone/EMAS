#!/bin/bash 
# Shell utilities used for managing and loading scenarios 

# Get an array of all the scenario directories available 
pushd "${SCENARIO_DIRECTORY}" > /dev/null
export SCENARIO_FAMILIES=($(ls -d */ | sed 's:/$::'))
popd > /dev/null

function list_scenarios() {
    printf "\n The available scenarios are: \n"

    for scenario_family in "${SCENARIO_FAMILIES[@]}"; do 
        printf " FAMILY ${COLOR_PURPLE}${scenario_family}${COLOR_NONE}\n"
        pushd "${SCENARIO_DIRECTORY}/${scenario_family}" > /dev/null

        SCENARIOS_IN_FAMILY=($(ls | sed 's:/$::'))

        for scenario in "${SCENARIOS_IN_FAMILY[@]}"; do 
            printf "\t-- ${COLOR_YELLOW}${scenario}${COLOR_NONE}\n"
        done 
        popd > /dev/null
    done 
}
