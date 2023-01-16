using Random

include("libspath.jl")
include("analysis.jl")
add_to_loadpath!("../MultiAgents.jl")

using MiniObserve

using SocioEconomics: SEVERSION, SEPATH, SESRCPATH 
@assert SEVERSION == v"0.3.1" 

using SocioEconomics.ParamTypes
import SocioEconomics.ParamTypes: load_parameters
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

function load_parameters(::WithInputFiles) 
    simPars, dataPars, pars = load_parameters(ARGS)
    seed!(simPars)
    simPars, dataPars, pars 
end  

function load_parameters(::Light)
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

function setup_logging(simPars; FS = "\t")
    if simPars.logfile == ""
        return nothing
    end
    file = open(simPars.logfile, "w")
    print_header(file, Data; FS)
    file
end

setup_logging(simPars,::WithInputFiles) = setup_logging(simPars)
setup_logging(simPars,::Light) = nothing 

close_logfile(loffile,::WithInputFiles) = close(logfile)
close_logfile(logfile,::Light) = nothing 