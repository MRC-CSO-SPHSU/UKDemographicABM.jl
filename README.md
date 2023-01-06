# LPM.jl
Implementation of the Lone Parents Model based on the SocioEconomics.jl Library. The initial code is based on the LoneParentsModel.jl package that was implemented together by Martin Hinsch and Atiyah Elsheikh.  

Releases
========

- **V0.1.0 (28.11.2022)** : The lone parent model (corresponding to LoneParentsModel.jl Version 0.6.1) based on the SocioEconomics.jl package V0.1.0 

   - V0.1.1 (29.11)  : Simplified usage of SocioEconomics Library 
   - V0.1.2 ( 1.12)  : "data parameters" and loading / handling parameters from command line and input files is now part of SE library within ParamTypes module
   - V0.1.3 ( 2.12)  : Utilties is a part of the SE* libraries (compatible with SE V0.1.3)  
   
- **V0.2.0 (5.12.2022)** : Unified API of CreateX and Initialize functions (compatible with SE V0.2)

   - V0.2.1 (7.12)   : (MALPM only) New Simulation Interface for 3 functions, doBirths!, doDeaths!, doDivorces, Improved API for parameter accessory functions, compatible with SE* Version 0.2.1
   - V0.2.2 (8.12)   : (MALPM only) doMarriages (SE* V0.2.2)
   - V0.2.3 (9.12)   : (MALPM only) adoptions, workTransitions, socialTransitions, ageTransitions (SE* V0.2.3)  
   - V0.2.4 (14.12)  : (MALPM only) adjusting to SimpleABM types of MA Version 0.4, improved model data structure 
   - V0.2.5 (21.12)  : (MALPM only) exploits some tuned simulation functions from SE* V0.2.5 and improved performance (3x faster)  
   - V0.2.6 (27.12)  : (MALPM only) Improved implementation of allocation algorithms (no temporary arrays), tuned do marriage algorithm (memoization can be avoided) & Improved runtime performance (3x faster & 4x less memory allocation and storage w.r.t. V0.2.5) 
   - V0.2.7 (6.1.2023) : (MALPM only) Memoization with domarriage alg can be done only externally (if desired). Employing newly tuned and exact API of four simulation functions. Optimized simulation (with deads removal) vs. normal simulation (without deads removal) 
