using Random

include("util.jl")
addToLoadPath!("../SocioEconomics.jl/src")
#addToLoadPath!("../SocioEconomics.jl/src/multiagents") 
addToLoadPath!("../MultiAgents.jl")
addToLoadPath!("./src")

using SocioEconomics: SEVERSION, SEPATH, SESRCPATH 

@assert SEVERSION == v"0.1.0" 

using SocioEconomics.ParamTypes

using XAgents

using SocioEconomics.Demography.Create
using SocioEconomics.Demography.Initialize
using SocioEconomics.Demography.Simulate

include("mainHelpers.jl")

using MultiAgents: initMultiAgents, MAVERSION
initMultiAgents()             # reset agents counter
@assert MAVERSION == v"0.3.1"   # ensure MultiAgents.jl latest update 


using SocioEconomics.ParamTypes: seed!
using MultiAgents: AbstractMABM, ABMSimulationP 
using MultiAgents: run!
using MALPM.Models: MAModel
using MALPM.Demography: LPMUKDemography, LPMUKDemographyOpt 
using MALPM.Demography.SimSetup: setup! 

"""
How simulations is to be executed: 
- with or without input files, arguments and logging 
""" 

abstract type MainSim end 
struct WithInputFiles <: MainSim end   # Input parameter files 
struct Light <: MainSim end            # no input files 

function loadParameters(::WithInputFiles) 
    simPars, pars = loadParameters(ARGS)
    seed!(simPars)
    simPars, pars 
end  

function loadParameters(::Light)
    simPars = SimulationPars()
    seed!(simPars)
    pars = DemographyPars()
    simPars, pars 
end

setupLogging(simPars,::WithInputFiles) = setupLogging(simPars)
setupLogging(simPars,::Light) = nothing 

closeLogfile(loffile,::WithInputFiles) = close(logfile)
closeLogfile(logfile,::Light) = nothing 