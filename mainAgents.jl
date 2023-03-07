"""
LPM using Agents.jl package
"""

include("libspath.jl")
add_to_loadpath!("../MultiAgents.jl")

using MultiAgents
init_majl()  # reset agents.id to 1
@assert MAVERSION == v"0.5"

using SocioEconomics: SEVERSION
@assert SEVERSION == v"0.3.3"

using MALPM.Models: DemographicABM
using SocioEconomics.XAgents:  DemographicMap

using SocioEconomics.ParamTypes

using SocioEconomics.Specification.Declare
using SocioEconomics.Specification.Initialize

const simPars = SimulationPars()
const dataPars = DataPars()
const pars = DemographyPars()

# significant parameters
simPars.seed = 0; ParamTypes.seed!(simPars)
simPars.verbose = false
simPars.checkassumption = false
simPars.sleeptime = 0
pars.poppars.initialPop = 500 # 28100 for 1-min simulation

const data = load_demography_data(dataPars)
#const ukTowns = create_inhabited_towns(pars)
#const ukPop = create_pyramid_population(pars)

# to fix
space = DemographicMap("The United Kingdom")
model = DemographicABM(space,pars,simPars,data)
declare_inhabited_towns!(model)
declare_population!(model)  # pyramid population
Initialize.init!(model,AgentsModelInit())

# create_population!(model)
