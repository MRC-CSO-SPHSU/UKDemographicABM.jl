"""
Main simulation of the lone parent model

Run this script from shell as
# julia mainMA.jl

from REPL execute it using
> include("mainMA.jl")
"""

include("src/maspec.jl")

using MultiAgents: ABMSimulatorP, FixedStepSimP
using MultiAgents: run!, setup!
using SocioEconomics.Specification.Initialize: init!

# const lpmExample = FullPopEx()    # don't remove deads
# const lpmExample = AlivePopEx()   # remove deads
const lpmExample = SimpleSimulatorEx() # dead removal and simple simulator

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
    # V0.4.4 58000 (2.17M, 536MB) for 1-min simulation / 153.45 (3.78M, 926 MB) sec for IPS = 100_000
    pars.poppars.initialPop =  5000 # 29100 # 50_000
end

const logfile = setup_logging(simPars,mainConfig)

const data = load_demography_data(dataPars)

const ukTowns =  Vector{PersonTown}(declare_inhabited_towns(pars))
const ukHouses = Vector{PersonHouse}()
const ukPop = SimpleABM{Person}(declare_pyramid_population(pars))
const ukDemography = MAModel(ukTowns, ukHouses, ukPop, pars, data, simPars.starttime)

applycaching(::SimProcess) = false
applycaching(::Birth) = true
init!(ukDemography;verify=false,applycaching)

_declare_simulator(pars,::LPMUKExample) =
    ABMSimulatorP{typeof(pars)}(pars,setupEnabled = false)
_declare_simulator(pars,::SimpleSimulatorEx) =
    FixedStepSimP{typeof(pars)}(pars)

const lpmDemographySim = _declare_simulator(simPars,lpmExample)

_setup_simulator!(simulator::ABMSimulatorP,example) = setup!(simulator,example)
_setup_simulator!(simulator::FixedStepSimP,example) = debug_setup(simulator.parameters)
_setup_simulator!(lpmDemographySim,lpmExample)

# Execution

_run_model!(model,simulator::ABMSimulatorP,example) = run!(model,simulator,example)
_run_model!(model,simulator::FixedStepSimP,example::SimpleSimulatorEx) =
    run!(model,pre_model_stepping!,agent_stepping!,post_model_stepping!,simulator,example)

@time _run_model!(ukDemography,lpmDemographySim,lpmExample)
close_logfile(logfile,mainConfig)
@info currenttime(ukDemography)
