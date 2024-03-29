include("utils/utils.jl")
add_to_loadpath!(pwd() * "/../ABMSim.jl")

using Random
using ABMSim: ABMSIMVERSION, init_abmsim
@assert ABMSIMVERSION == v"0.7.1"
init_abmsim()  # reset agents id counter

include("spec/components.jl")
include("spec/ma/model.jl")
include("spec/ma/simulate.jl")
include("spec/ma/simsetup.jl")

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
