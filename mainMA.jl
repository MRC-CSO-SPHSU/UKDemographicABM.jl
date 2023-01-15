"""
Main simulation of the lone parent model 

Run this script from shell as 
# julia mainMA.jl

from REPL execute it using 
> include("mainMA.jl")
"""

include("mainMAHelpers.jl")

using MultiAgents: ABMSimulatorP
using MultiAgents: run!, setup! 
using MALPM.Models: MAModel
using SocioEconomics.Specification.Initialize: init!
using MALPM.Examples

const mainConfig = Light()    # no input files, logging or flags (REPL Exec.) 
# mainConfig = WithInputFiles()

# lpmExample = LPMUKDemography()    # don't remove deads
lpmExample = LPMUKDemographyOpt()   # remove deads 

const simPars, dataPars, pars = loadParameters(mainConfig) 

# Most significant simulation and model parameters 
# The following works only with Light() configuration
#   useful when executing from REPL
if mainConfig == Light() 
    simPars.seed = 0; seed!(simPars)
    simPars.verbose = false     
    simPars.checkassumption = false 
    simPars.sleeptime = 0
    pars.poppars.initialPop = 5000
end

const logfile = setupLogging(simPars,mainConfig)

const data = loadDemographyData(dataPars)

const ukTowns, ukHouses, ukPop = create_uk_demography(pars,data)

const ukDemography = MAModel(ukTowns, ukHouses, ukPop, pars, data)

init!(ukDemography)

const lpmDemographySim = 
    ABMSimulatorP{typeof(simPars)}(simPars,setupEnabled = false)
    
setup!(lpmDemographySim,lpmExample) 
 
# Execution 
@time run!(ukDemography,lpmDemographySim,lpmExample)

closeLogfile(logfile,mainConfig)
 
