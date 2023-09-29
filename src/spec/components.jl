include("../utils/utils.jl")
add_to_loadpath!(pwd() * "/../UKSEABMLib.jl/src")
add_to_loadpath!(pwd() * "/src")
add_to_loadpath!(pwd() * "/../ABMSim.jl")

using ABMSim: ABMSIMVERSION, init_abmsim
@assert ABMSIMVERSION == v"0.7.1"
init_abmsim()  # reset agents id counter

using UKSEABMLib: SEVERSION
@assert SEVERSION == v"0.6"  # Performance tuning

using UKSEABMLib.ParamTypes # Model parameters
using UKSEABMLib.XAgents # Basic agent types
using UKSEABMLib.Specification.Declare # Model Components declaration
using UKSEABMLib.Specification.Initialize # Model initialization
using UKSEABMLib.API.Traits # Population, Simulation Processes and operation traits
using UKSEABMLib.Specification.SimulateNew

import UKSEABMLib.ParamTypes: load_parameters
function load_parameters()
    simPars = SimulationPars()
    ParamTypes.seed!(simPars)
    dataPars = DataPars()
    pars = DemographyPars()
    simPars, dataPars, pars
end
