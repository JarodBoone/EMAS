# EMAS 
Emerging Memory Architecture Simulator. 

This is a general purpose GEM5 based simulator capable of modeling any combination of emerging memory techonologies. Current supported technologies are: 

- Near Data Processing 
- Processing in Memory 
- Non Volatile Memory 

## Requirements 

- Gem5 build requirements 
- Bash interpreter 
- The system is tested on Linux distrobutions

## Usage 

EMAS builds and runs simulations through a **scenario** interface. The scripts that define scenarios are found in **/Scenarios**. 

Each scenario belongs to a family. A scenario family encompasses a specific hardware configuration and disk image while the individual instances typically specify a workload or parameters for the hardware configuration. 

Each scenario family must have a bash script called `build`. This is required to build a scenario

First you need to build a scenario a scenario family and it will create a build directory in the work folder then you can run that scenario. 

When Building a scenario 
- Identify valid scenario string 
- Export build options 
- run gem5 build into the 

I probably need to limit the number of things that are built at a time 

Need to nail down the scenario naming convention: `family.number`. All families have the same build? Maybe idk 

## Documentation 

General overview - see docs 
Usage - see docs 

**bd** = base directory

## Runtime 

The basic EMAS runtime is conducted through the interface bash scripts (found in /Interface). The user executes EMAS commands in the form of bash scripts (found in /Interface/Commands)

### Configuration Paradigm 

The EMAS runtime relies on a proper configuration. This more or less means that the directory containing EMAS.sh has the expected directory structure.

- **bd**/config: Contains definitions of absolute pointers to important EMAS directories and such. 

The state of EMAS is represented by **bd**/state which more or less keeps track. If EMAS is validly configured then it is keeping consistent track of the state. 

The first time you start up you will not be configured



### General Case Sequence of Actions 

- First thing we do is include all of the shell variables. Configuration and state 
- Passive Config check 
- Offer active configuration
- Need to check that state is consistent if we have configured before. Configuration consists of 
    - Checking Installs 
    - Checking Directory Structure 
    - Establishing State file and locking state. (Flag configuration) 

### API 

Run these commands with `EMAS (command)` 


## Models 

Here is for specifying models and various tools for verifying them Each model should be added as a GEM5 extra 

Technology 
|--- Configurations 
|--- Verification 
|--- Gem5 source

## Development steps 

- Installed latest version of gem5 to **base/Simulator/GEM5/gem5**. Removed Git and mercurial version control (hooks and version history) but keep gitignore 
- Made a basic shell interface for EMAS 
- Implemented `build` command which is a wrapper to build gem5 
    - Figure out where to put the scenario directory and how to manage them 
- Ok Apparently I can't use the gem5img.py disk utility to create and manage disk images so I will have to do that myself uhhhh 

### TODO

- Use state variables or config to verify Gem5 version 


