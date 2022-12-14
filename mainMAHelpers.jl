using Random

include("libspath.jl")
addToLoadPath!("../MultiAgents.jl")

using SocioEconomics: SEVERSION, SEPATH, SESRCPATH 

@assert SEVERSION == v"0.2.4" 

using SocioEconomics.ParamTypes

using SocioEconomics.XAgents

using SocioEconomics.Specification.Create
using SocioEconomics.Specification.Initialize
using SocioEconomics.Specification.Simulate

include("mainHelpers.jl")

using MultiAgents: init_majl
init_majl()             # reset agents id counter

using SocioEconomics.ParamTypes: seed!

"""
How simulations is to be executed: 
- with or without input files, arguments and logging 
""" 
abstract type MainSim end 
struct WithInputFiles <: MainSim end   # Input parameter files 
struct Light <: MainSim end            # no input files 

function loadParameters(::WithInputFiles) 
    simPars, dataPars, pars = loadParameters(ARGS)
    seed!(simPars)
    simPars, dataPars, pars 
end  

function loadParameters(::Light)
    simPars = SimulationPars()
    seed!(simPars)
    dataPars = DataPars() 
    pars = DemographyPars()
    simPars, dataPars, pars 
end

setupLogging(simPars,::WithInputFiles) = setupLogging(simPars)
setupLogging(simPars,::Light) = nothing 

closeLogfile(loffile,::WithInputFiles) = close(logfile)
closeLogfile(logfile,::Light) = nothing 