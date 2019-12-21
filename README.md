# EMAS 
Emerging Memory Architecture Simulator. 

This is a general purpose GEM5 based simulator capable of modeling any combination of emerging memory techonologies. Current supported technologies are 

- Near Data Processing 
- Processing in Memory 
- Non Volatile Memory 

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


