#!/bin/bash 

function EMAS_config() {
    # Lets build 
    if [ $__EMAS_IS_CONFIGURED = true ]; then 
        print_warning "It appears that EMAS is already configured on this machine"
        
        if ask "Are you sure you would like to reconfigure EMAS?"; then
            print_message "You have chosen to reconfigure EMAS"
        else 
            print_message "You have chosen not to reconfigure EMAS"
            exit_EMAS
            return
        fi 
    fi 

    cat "${STATE_FILE_DEFAULT}" > "${STATE_FILE}"

    print_message "... Configuring EMAS"

    if ! check_work_directory $ACTIVE; then 
        print_error "EMAS is not properly configured on this machine"
        exit_EMAS
    fi 

    if ! check_scenario_directory $ACTIVE; then 
        print_error "EMAS is not properly configured on this machine"
        exit_EMAS
    fi 

    update_state __EMAS_IS_CONFIGURED $TRUE
    print_success "EMAS has been properly configured on this machine! Run again to use the simulator :)"
    exit_EMAS
}

function EMAS_unconfig() {
    # Lets build 
    print_message "... Unconfiguring EMAS"

    update_state __EMAS_IS_CONFIGURED $FALSE

    print_success "EMAS has been unconfigured on this machine!"
    exit_EMAS
}