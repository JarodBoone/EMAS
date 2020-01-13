# EMAS 
Emerging Memory Architecture Simulator. 

This is a general purpose GEM5 based simulator capable of modeling any combination of emerging memory techonologies. Current supported technologies are 

- Near Data Processing 
- Processing in Memory 
- Non Volatile Memory 

## Usage 

First you need to build a scenario and it will create a build directory in the work folder then you can run that scenario. 

When Building a scenario 
- Identify valid scenario string 
- Export build options 
- run gem5 build into the 

I probably need to limit the number of things that are built at a time 

Need to nail down the scenario naming convention. `family.number`. All families have the same build? Maybe idk 

## Documentation 

General overview - see docs 
Usage - see docs 

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


