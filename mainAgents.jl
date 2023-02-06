include("libspath.jl")
add_to_loadpath!("../MultiAgents.jl")

using Agents
using SocioEconomics.XAgents: Person, PersonHouse, UNDEFINED_HOUSE
using SocioEconomics.ParamTypes
using SocioEconomics.Specification.Create
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

const ukTowns = create_inhabited_towns(pars)
const ukHouses = PersonHouse[]
const ukPop = create_pyramid_population(pars)

# to fix
space = UNDEFINED_HOUSE
model = AgentBasedModel(Person,space)
