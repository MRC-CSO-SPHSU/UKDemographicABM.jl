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
# const mainConfig = WithInputFiles()

# lpmExample = LPMUKDemography()    # don't remove deads
lpmExample = LPMUKDemographyOpt()   # remove deads 

const simPars, dataPars, pars = load_parameters(mainConfig) 

# Most significant simulation and model parameters 
# The following works only with Light() configuration
#   useful when executing from REPL
if mainConfig == Light() 
    simPars.seed = 0; seed!(simPars)
    simPars.verbose = false     
    simPars.checkassumption = false 
    simPars.sleeptime = 0
    pars.poppars.initialPop = 5000 # 28100 for 1-min simulation
end

const logfile = setup_logging(simPars,mainConfig)

const data = load_demography_data(dataPars)

const ukTowns, ukHouses, ukPop = create_uk_demography(pars,data)

const ukDemography = MAModel(ukTowns, ukHouses, ukPop, pars, data)

init!(ukDemography)

const lpmDemographySim = 
    ABMSimulatorP{typeof(simPars)}(simPars,setupEnabled = false)
    
setup!(lpmDemographySim,lpmExample) 
 
# Execution 
@time run!(ukDemography,lpmDemographySim,lpmExample)

close_logfile(logfile,mainConfig)
 
