#!/bin/bash 
# Various shell scripts to verify and setup simulation runtime 

# Make sure that there is a work directory 
function setup_work_directory() {

    # Check to see if the work directory exists, if it does not make one 
    if [ ! -d "${WORK_DIRECTORY}" ]; then 
        print_warning "No Work directory found. Creating one at ${WORK_DIRECTORY}"
        mkdir -p "${WORK_DIRECTORY}" 
    else 
        print_success "Found Work directory at ${COLOR_GRAY}${WORK_DIRECTORY}${COLOR_NONE}"
    fi
}

function setup_scenario_work_directory() {
    echo "yeah"
}

function build_scenario() {
    echo "whoa"
}