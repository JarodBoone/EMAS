#!/bin/bash 

# ask for yes or no before running a function
function ask() { 
    while true; do
        read -p "$1" yn
        case $yn in
            [Yy]* ) $2; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

function exit_EMAS() { 
    print_goodbye
    exit
}