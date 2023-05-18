using Random

include("./modelspec.jl")
using MultiAgents: SimpleABM

add_to_loadpath!(pwd() * "/src/utils/MiniObserve/src")
using MiniObserve
include("utils/analysis.jl")

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
load_parameters(::Light) = load_parameters()

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
