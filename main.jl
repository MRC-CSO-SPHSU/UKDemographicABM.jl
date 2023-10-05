"""
Main simulation of a demographic ABM simulation of the UK

Run this script from shell as
# julia main.jl

from REPL execute it using
> include("main.jl")

Since V0.5, ABMSim.jl V0.6.1 is used instead of deprectatd MultiAgents.jl accessible
under (https://github.com/AtiyahElsheikh/MultiAgents.jl)

Since V0.6, UKSEABMLib.jl V0.6 is used instead of depracted SocioEconomics.jl accessible under
(https://github.com/AtiyahElsheikh/SocioEconomics.jl)
"""

include("src/maspec.jl")

using ABMSim: ABMSimulatorP, FixedStepSimP
using ABMSim: run!, setup!, nagents
using UKSEABMLib.Specification.Initialize: init!

# const mainExample = FullPopEx()    # don't remove deads
# const mainExample = AlivePopEx()   # remove deads
const mainExample = SimpleSimulatorEx() # dead removal and simple simulator

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
    # V0.4.5 59000 (2.34M, 552MB) for 1-min simulation / 151.45 (3.76M, 922 MB) sec for IPS = 100_000
    pars.poppars.initialPop = 5000 # 5000 # 29500 # 50_000
end

const logfile = setup_logging(simPars,mainConfig)

const data = load_demography_data(dataPars)

const ukTowns =  Vector{PersonTown}(declare_inhabited_towns(pars))
const ukHouses = Vector{PersonHouse}()
const ukPop = SimpleABM{Person}(declare_pyramid_population(pars))
@info "population size " * string(nagents(ukPop))
const ukDemography = MAModel(ukTowns, ukHouses, ukPop, pars, data, simPars.starttime)

applycaching(::SimProcess) = false
applycaching(::Birth) = true
init!(ukDemography;verify=false,applycaching)

_declare_simulator(pars,::AbsExample) =
    ABMSimulatorP{typeof(pars)}(pars,setupEnabled = false)
_declare_simulator(pars,::SimpleSimulatorEx) =
    FixedStepSimP{typeof(pars)}(pars)

const demographySim = _declare_simulator(simPars,mainExample)

_setup_simulator!(simulator::ABMSimulatorP,example) = setup!(simulator,example)
_setup_simulator!(simulator::FixedStepSimP,example) = debug_setup(simulator.parameters)
_setup_simulator!(demographySim,mainExample)

# Execution

_run_model!(model,simulator::ABMSimulatorP,example) = run!(model,simulator,example)
_run_model!(model,simulator::FixedStepSimP,example::SimpleSimulatorEx) =
    run!(model,pre_model_stepping!,agent_stepping!,post_model_stepping!,simulator,example)

@time _run_model!(ukDemography,demographySim,mainExample)
close_logfile(logfile,mainConfig)
@info currenttime(ukDemography)
