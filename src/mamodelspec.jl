using Random

include("utils/utils.jl")
add_to_loadpath!(pwd() * "/../SocioEconomics.jl/src")
add_to_loadpath!(pwd())
add_to_loadpath!(pwd() * "/src")

include("../analysis.jl")
add_to_loadpath!(pwd() * "/../MultiAgents.jl")

using MiniObserve

using SocioEconomics: SEVERSION, SEPATH, SESRCPATH
@assert SEVERSION == v"0.4.2"  # Integration of Agents.jl space concept

using SocioEconomics.ParamTypes
import SocioEconomics.ParamTypes: load_parameters
using SocioEconomics.XAgents
using SocioEconomics.Specification.Declare
using SocioEconomics.Specification.Initialize

using MultiAgents: init_majl, MAVERSION
using MultiAgents: SimpleABM
@assert MAVERSION == v"0.5"
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

function declare_uk_demography(pars,data)
    ukTowns =  Vector{PersonTown}(declare_inhabited_towns(pars))
    ukHouses = Vector{PersonHouse}()
    ukPopulation = SimpleABM{Person}(declare_pyramid_population(pars))
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
