using Random

include("libspath.jl")
include("analysis.jl")
addToLoadPath!("../MultiAgents.jl")

using MiniObserve

using SocioEconomics: SEVERSION, SEPATH, SESRCPATH 
@assert SEVERSION == v"0.3" 

using SocioEconomics.ParamTypes
import SocioEconomics.ParamTypes: loadParameters
using SocioEconomics.XAgents
using SocioEconomics.Specification.Create
using SocioEconomics.Specification.Initialize

# include("mainHelpers.jl")

using MultiAgents: init_majl
using MultiAgents: SimpleABM
init_majl()             # reset agents id counter

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

function create_uk_demography(pars,data) 
    ukTowns =  SimpleABM{PersonTown}(create_inhabited_towns(pars)) 
    ukHouses = SimpleABM{PersonHouse}() 
    ukPopulation = SimpleABM{Person}(create_pyramid_population(pars))
    ukTowns, ukHouses, ukPopulation
end

function setupLogging(simPars; FS = "\t")
    if simPars.logfile == ""
        return nothing
    end
    file = open(simPars.logfile, "w")
    print_header(file, Data; FS)
    file
end

setupLogging(simPars,::WithInputFiles) = setupLogging(simPars)
setupLogging(simPars,::Light) = nothing 

closeLogfile(loffile,::WithInputFiles) = close(logfile)
closeLogfile(logfile,::Light) = nothing 