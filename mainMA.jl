"""
Main simulation of the lone parent model

Run this script from shell as
# julia mainMA.jl

from REPL execute it using
> include("mainMA.jl")
"""

include("src/maspec.jl")

using MultiAgents: ABMSimulatorP
using MultiAgents: run!, setup!
using SocioEconomics.Specification.Initialize: init!

# const lpmExample = FullPopEx()    # don't remove deads
const lpmExample = AlivePopEx()   # remove deads

const mainConfig = Light()    # no input files, logging or flags (REPL Exec.)
# const mainConfig = WithInputFiles()

const simPars, dataPars, pars = load_parameters(mainConfig)

# Most significant simulation and model parameters
# The following works only with Light() configuration
#   useful when executing from REPL
if mainConfig == Light()
    simPars.seed = 0; ParamTypes.seed!(simPars)
    simPars.verbose = false
    simPars.checkassumption = false
    simPars.sleeptime = 0
    # V0.4.2 28500 for 1-min simulation / 162 sec for IPS = 100_000
    pars.poppars.initialPop = 28500
end

const logfile = setup_logging(simPars,mainConfig)

const data = load_demography_data(dataPars)

const ukTowns =  Vector{PersonTown}(declare_inhabited_towns(pars))
const ukHouses = Vector{PersonHouse}()
const ukPop = SimpleABM{Person}(declare_pyramid_population(pars))
const ukDemography = MAModel(ukTowns, ukHouses, ukPop, pars, data, simPars.starttime)

init!(ukDemography,verify=false)

const lpmDemographySim =
    ABMSimulatorP{typeof(simPars)}(simPars,setupEnabled = false)

setup!(lpmDemographySim,lpmExample)

# Execution
@time run!(ukDemography,lpmDemographySim,lpmExample)
close_logfile(logfile,mainConfig)
#@info currenttime(ukDemography)
