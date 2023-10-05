Performance Progress History 
============================

The following is the progress history of executing mainMA.jl on a personal labtop equipped with 2.5 GHz processor (11th Gen. Intel i9-11900) & Memory of 32 GB. The parameter values and data used are given within [SocioEconomics.ParamTypes module](https://github.com/MRC-CSO-SPHSU/SocioEconomics.jl/tree/V0.3.1/src/socioeconomics/paramtypes)

Version   |   Runtime  |  # Memory Allocation | Storage used | Comment 
--- | --- | --- | --- | ---
0  | ~29 sec. | ~ 400 M | 12.5 GB | The state of LoneParentsModel.jl before starting this repo.  
V0.2.3 | 29 sec. | ~ 360 M | ~ 14 GB | execution with main.jl was quite faster but consumed more memory and storage 
V0.2.4 | 21.5 sec. | ~ 280 M | ~ 10.5 GB | MA Version 0.4
V0.2.5 | 20 sec. | ~ 155 M | ~ 8 GB |  
V0.2.6 | 7.6 sec. | ~ 37 M | ~ 2.2 GB | 
V0.2.8 | 6.3 sec. | ~ 24 M | ~ 1.6 GB |
V0.3 | 4.7 sec | ~ 380 k | ~ 90 MB | 
V0.4.2 | 4.44 sec | ~ 354 k | 88 MB | Julia Version 1.9
V0.4.4 | 4.33 sec | ~ 370 k | 90 MB | 
V0.4.5 | 3.89 | 372 k | 90 MB | 

The following are performance statistics (IPS : Initial Population Size) on a dell laptob (11th Gen. Intel@ core i9-1900H @ 2.5 GnZ) x 16, 32 GB Memory :

Version | 1 Minute simulation with IPS of | IPS = 50,000 | IPS = 500,000
--- | --- | --- | --- 
0.3.1 | 28100 (~ 2.1 M A. + 520 MB) | ~ 168 secs  (3.84 M A., 930 MB) | 5 hours 11 min (40.04 M A., 9.116 GB)
0.4.2 | 28500 (~ 2.08 M A. + 518 MB) | ~ 162 secs (3.77 M A., 929 MB) | ?  
0.4.4 | 29000 (~ 2.17 M A. + 536 MB) | ~ 153.5 secs (3.78 M , 926 MB) | 5 hours 1 min (38.95 M A. , 9.022 GB) 
0.4.5 | 29000 (~2.23 M A. + 552 MB) | 151 secs (3.76 M, 922 MB) | 4 hours 53 min (38.83 M. A., 9.000 GB)

Runtime performance of mainAgents.jl is quite comparible. However, fair comparison desires further tuning of the model and accessory function implemnetation

Backward compatibility issues
=======

- Since V0.5, ABMSim.jl V0.6.1 is used instead of the deprecated package [MultiAgents.jl](https://github.com/AtiyahElsheikh/MultiAgents.jl) 

- Since V0.6, UKSEABMLib.jl V0.6 is used instead of the deprecated package [SocioEconomics.jl](https://github.com/AtiyahElsheikh/SocioEconomics.jl)
