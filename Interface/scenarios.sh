#!/bin/bash 
# Shell utilities used for managing and loading scenarios 

# Get an array of all the scenario directories available 
pushd "${SCENARIO_DIRECTORY}" > /dev/null
export SCENARIO_FAMILIES=($(ls -d */ | sed 's:/$::'))
popd > /dev/null

# List all the scenario names and their corresponding indices 
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
                printf "\t[Instance ${COLOR_YELLOW}${scenario}${COLOR_NONE}] ($__FAMILY_COUNT.$__INSTANCE_COUNT | $scenario_family.$__INSTANCE_COUNT): \n"
                __INSTANCE_COUNT=$((__INSTANCE_COUNT + 1))
            fi 
            
        done 

        __FAMILY_COUNT=$((__FAMILY_COUNT + 1))
        popd > /dev/null
    done 
}

# Variables for choosing and accessing scenarios 
export TARGET_SCENARIO_FAMILY=""                # Plaintext family name
export TARGET_SCENARIO_FAMILY_INDEX=""          # Integer family index
export TARGET_SCENARIO_INSTANCE=""              # Integer instance index

export TARGET_FAMILY_BUILD_SCRIPT=""            # Absolute path of the family build script 
export TARGET_INSTANCE_SCRIPT=""                # Absolute path of the scenario instance script

export TARGET_FAMILY_WORK_DIR=""                # Absolute path of the scenario family work directory 
export TARGET_INSTANCE_WORK_DIR=""              # Absolute path of the scenario instance work directory 

# Function to parse a scenario family name or index and set target variables
# 1 --> string of format "family.instance" to parse
function target_scenario_family() { 
    if [ $# -ne 1 ] ; then 
        print_error "Internal Error: incorrect number of arguments to target_scenario"
        exit_EMAS
    fi

    # 1st argument is the scenario name to parse
    SCENARIO_NAME_RAW=$1

    # Convert to Family and instance code 
    SAVEIFS=$IFS
    IFS="."
    read -r -a array <<< "$SCENARIO_NAME_RAW"
    IFS=$SAVEIFS

    REQUIRED_SCENARIO_COMPONENTS=2
    N_COMPONENTS=${#array[@]}

    if (($REQUIRED_SCENARIO_COMPONENTS < $N_COMPONENTS)); then 
        print_error "\"$1\" is not a properly formatted scenario"
        return $FAIL
    fi  

    INPUT_FAMILY=${array[0]}

    print_message "input scenario family: \"${INPUT_FAMILY}\""

    if is_number $INPUT_FAMILY ; then 
        print_message "family input is a number ... resolving to name"

        if (($INPUT_FAMILY >= ${#SCENARIO_FAMILIES[@]})); then 
            print_error "scenario family index $INPUT_FAMILY too big"
            print_message "list available scenarios with ${COLOR_PURPLE}EMAS list${COLOR_NONE}"
            return $FAIL
        fi 

        TARGET_SCENARIO_FAMILY_INDEX=$INPUT_FAMILY
        TARGET_SCENARIO_FAMILY=${SCENARIO_FAMILIES[$INPUT_FAMILY]}
    else 
        

        for i in ${!SCENARIO_FAMILIES[@]}; do 
            if [[ "${SCENARIO_FAMILIES[$i]}" == "${INPUT_FAMILY}" ]]; then 
                TARGET_SCENARIO_FAMILY_INDEX=$i
            fi 
        done 

        if [[ "${TARGET_SCENARIO_FAMILY_INDEX}" == "" ]]; then 
            print_error "\"$INPUT_FAMILY\" is not an existing scenario family"
            print_message "list available scenarios with ${COLOR_PURPLE}EMAS list${COLOR_NONE}"
            return $FAIL
        fi 

        TARGET_SCENARIO_FAMILY=$INPUT_FAMILY

    fi

    TARGET_FAMILY_BUILD_SCRIPT="${SCENARIO_DIRECTORY}/${TARGET_SCENARIO_FAMILY}/build"
    TARGET_FAMILY_WORK_DIR="${SCENARIO_OUTPUT_DIRECTORY}/${TARGET_SCENARIO_FAMILY}"
}

# Function to parse a scenario name or index and set target variables
# 1 --> string of format "family.instance" to parse
function target_scenario_instance() { 
    if [ $# -ne 1 ] ; then 
        print_error "Internal Error: incorrect number of arguments to target_scenario"
        exit_EMAS
    fi

    if ! target_scenario_family $1; then
        return $FAIL
    fi

    # 1st argument is the scenario name to parse
    SCENARIO_NAME_RAW=$1

    # Convert to Family and instance code 
    SAVEIFS=$IFS
    IFS="."
    read -r -a array <<< "$SCENARIO_NAME_RAW"
    IFS=$SAVEIFS

    REQUIRED_SCENARIO_COMPONENTS=2
    N_COMPONENTS=${#array[@]}

    if (($REQUIRED_SCENARIO_COMPONENTS < $N_COMPONENTS)); then 
        print_error "\"$1\" is not a properly formatted scenario"
        return $FAIL
    fi  

    if (($N_COMPONENTS == 1)); then 
        print_warning "No scenario instance provided. Default to instance 0"
        TARGET_SCENARIO_INSTANCE=0
    else 
        INPUT_INSTANCE=${array[1]}
        print_message "input scenario instance: \"${INPUT_INSTANCE}\""
        if ! is_number $INPUT_INSTANCE; then 
            print_error "instance name must be an integer"
            return $FAIL 
        fi

        TARGET_SCENARIO_INSTANCE=$INPUT_INSTANCE
    fi 

    if [ ! -f "${SCENARIO_DIRECTORY}/${TARGET_SCENARIO_FAMILY}/${TARGET_SCENARIO_INSTANCE}" ]; then 
        print_error "no instance ${TARGET_SCENARIO_INSTANCE} of scenario family ${TARGET_SCENARIO_FAMILY}"
        print_message "list available scenarios with ${COLOR_PURPLE}EMAS list${COLOR_NONE}"
        return $FAIL
    fi 

    if [ ! -f "${SCENARIO_DIRECTORY}/${TARGET_SCENARIO_FAMILY}/build" ]; then 
        print_error "internal error: could not find ${TARGET_SCENARIO_FAMILY} build script"
        return $FAIL
    fi 

    TARGET_INSTANCE_SCRIPT="${SCENARIO_DIRECTORY}/${TARGET_SCENARIO_FAMILY}/${TARGET_SCENARIO_INSTANCE}"
    TARGET_INSTANCE_WORK_DIR="${TARGET_FAMILY_WORK_DIR}/${TARGET_SCENARIO_INSTANCE}"

    print_ok "Targeted scenario: $TARGET_SCENARIO_FAMILY.$TARGET_SCENARIO_INSTANCE [$TARGET_SCENARIO_FAMILY_INDEX.$TARGET_SCENARIO_INSTANCE]"

}

# Function to check if a scenario has been targeted at all 
function scenario_targeted() { 
    if [[ "${TARGET_SCENARIO_FAMILY}" == "" ]]; then 
        return $FAIL
    else 
        return $SUCCESS
    fi
}


# Create new scenario family 
# Create new secnario in family 