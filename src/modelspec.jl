include("utils/utils.jl")
add_to_loadpath!(pwd() * "/../SocioEconomics.jl/src")
add_to_loadpath!(pwd())
add_to_loadpath!(pwd() * "/src")
add_to_loadpath!(pwd() * "/../MultiAgents.jl")

using MultiAgents: MAVERSION, init_majl
@assert MAVERSION == v"0.5.0"
init_majl()  # reset agents id counter

using SocioEconomics: SEVERSION
@assert SEVERSION == v"0.4.2"  # Integration of Agents.jl space concept

using SocioEconomics.ParamTypes
using SocioEconomics.XAgents
using SocioEconomics.Specification.Declare
using SocioEconomics.Specification.Initialize

import SocioEconomics.ParamTypes: load_parameters

function load_parameters()
    simPars = SimulationPars()
    ParamTypes.seed!(simPars)
    dataPars = DataPars()
    pars = DemographyPars()
    simPars, dataPars, pars
end
