# Scenarios 
Put Your scenarios here 

## Anatomy 
Consider the directory containing this readme (**EMAS/Scenarios/**) to be **SCENARIO_DIR**

Each of the subdirectories within **SCENARIO_DIR** defines a "scenario family" that can be built. Each file within the subdirectory should be a script that defines the building and runtime options for the scenarios in the family. 

The scripts have two categories 
- **build** : The family build information. Only one is allowed per family and should be named "build". This contains all of the parameters for compiling the simulator binary. 
- **instance** : Runtime information for a particular experiment (instance) to run on the compiled binary. Multiple are allowed per family and they should be named as integers starting with 0

A sample scenario family subdirectory would look like this 

+-- example_scenario
|   +-- build
|   +-- 0
|   +-- 1 
|   +-- 2

## Variables 
The scenario scripts alter various bash variables to configure the simulation environment and runtime. Below is a list of all parameters for family build scripts and instance scripts 

### Build Script Variables
|   **Variable Name**   | **Description** | **Possible Values** | **Default Value** |
|:-----------------:|:-----------:|:---------------:|:-------------:|
|   GEM5_SIM_MODE   |  The type of gem5 binary to build      |     [opt,debug,fast]            |        opt       |
| GEM5_SIM_PLATFORM |       The architecture to build      |         [alpha,arm,x86,riscv]        |       arm       |
|                   |             |                 |               |

### Instance Script Variables
|   **Variable Name**   | **Description** | **Possible Values** | **Default Value** |
|:-----------------:|:-----------:|:---------------:|:-------------:|
|   GEM5_SIM_MODE   |  The type of gem5 binary to build      |     [opt,debug,fast]            |        opt       |
| GEM5_SIM_PLATFORM |       The architecture to build      |         [alpha,arm,x86,riscv]        |       arm       |
|                   |             |                 |               |