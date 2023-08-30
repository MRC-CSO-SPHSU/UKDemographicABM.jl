# UKDemographicABM.jl

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

### Title 

UKDemographicABM.jl: A demographic Agent-based model of the UK

### Description 

Implementation of a demographic agent-based model of the UK based on the UKSEABMLib.jl [1] and employs an agent-based model simulator tool, ABMSim.jl [2] and Agents.jl package [3]. The implementation based on Agents.jl is just a first attempt and is subject to tuning. The model is a re-implementation of the demographic part of the Lone Parent Model implemented in Python [4]. The code is extended from from LoneParentsModel.jl V0.6.1 [5].  

### Releases

- **V0.1.0 (28.11.2022)** : The lone parent model (corresponding to LoneParentsModel.jl Version 0.6.1) based on the SocioEconomics.jl package V0.1.0 

   - V0.1.1 (29.11)  : Simplified usage of SocioEconomics Library 
   - V0.1.2 ( 1.12)  : "data parameters" and loading / handling parameters from command line and input files is now part of SE library within ParamTypes module
   - V0.1.3 ( 2.12)  : Utilties is a part of the SE* libraries (compatible with SE V0.1.3)  
   
- **V0.2.0 (5.12.2022)** : Unified API of CreateX and Initialize functions (compatible with SE V0.2)
   - Remark: main.jl is no longer maintained.  

   - V0.2.1 (7.12)   : New Simulation Interface for 3 functions, doBirths!, doDeaths!, doDivorces, Improved API for parameter accessory functions, compatible with SE* Version 0.2.1
   - V0.2.2 (8.12)   : doMarriages (SE* V0.2.2)
   - V0.2.3 (9.12)   : adoptions, workTransitions, socialTransitions, ageTransitions (SE* V0.2.3)  
   - V0.2.4 (14.12)  : adjusting to SimpleABM types of MA Version 0.4, improved model data structure 
   - V0.2.5 (21.12)  : exploits some tuned simulation functions from SE* V0.2.5 and improved performance  
   - V0.2.6 (27.12)  : Improved implementation of allocation algorithms (no temporary arrays), tuned do marriage algorithm (memoization can be avoided) & Improved runtime performance (3x faster & 4x less memory allocation and storage w.r.t. V0.2.5) 
   - V0.2.7 (6.1.2023) :  Memoization with domarriage alg can be done only externally (if desired). Employing newly tuned and exact API of four simulation functions. Optimized simulation (with deads removal) vs. normal simulation (without deads removal) 
   - V0.2.8 (8.1.2023) :  employing tuned API of assigning guardians 
- **V0.3 (14.01.2023)** : Making use of the rest of the fixed API of SE's Simulate function, further code simplification and tuning. Signficant memory allocation reduction and runtime performance improvement  
   - V0.3.1 (16.1) : Blue style badge, separating mainMAHelpers.jl from mainHelpers.jl, arbitrary population size
   - V0.3.2 (20.1) : Employing the blue-styled SE V0.3.2 
- **V0.4 (14.03.2023)** : Compatible with SE Version SE0.4, started an Agents.jl-based main program, moving unsed code to deprecated 
   - V0.4.1 (15.5) : another main simulation program based on Agents.jl  
   - V0.4.2 (16.5) : simplification of main simulation functions (now without time argument)
   - V0.4.3 (19.5) : improved code structure, simulation with a simple simulator type 
   - V0.4.4 (23.5) : caching pre-computations and little tuning
 
- **V0.5 (29.8.2023)**: Employing ABMSim V0.6 rather than MultiAgents, SE V0.5, bug fixes for mainAgents.jl, removing unnecessary code
- **V0.6 (30.8.2023)**: Renaming SocioEconomics.jl to UKSEABMLib.jl, renaming LPM.jl to UKDemographicABM.jl 

### Performance Progress History 

See [here](https://github.com/MRC-CSO-SPHSU/LPM.jl/blob/master/Performance.md)

### License 

MIT License

Copyright (c) 2023 Atiyah Elsheikh, MRC/CSO Social & Public Health Sciences Unit, School of Health and Wellbeing, University of Glasgow, Cf. [License](https://github.com/MRC-CSO-SPHSU/UKDemographicABM.jl/blob/master/LICENSE) for further information

### Platform 

This code was developed and experimented on 
- Ubuntu 22.04.2 LTS
- VSCode V1.71.2
- Julia language V1.9.1
- Agents.jl V5.14.0

### Exeution 

This is a library with no internal examples. However, cf. [LPM.jl package](https://github.com/MRC-CSO-SPHSU/LPM.jl) as an example. Execution of unit tests within REPL: 

<code>  
  > include("main.jl")
  > # or 
  > include("mainAgents.jl")  # for using Agents.jl 
</code> 
