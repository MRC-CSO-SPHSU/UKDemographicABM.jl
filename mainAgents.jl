"""
LPM using Agents.jl package
"""

include("libspath.jl")
add_to_loadpath!("../MultiAgents.jl")

using MultiAgents
using Agents

init_majl()  # reset agents.id to 1
@assert MAVERSION == v"0.5"

using SocioEconomics: SEVERSION
@assert SEVERSION == v"0.4.1"

using MALPM.Models: DemographicABM, currenttime

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
pars.poppars.initialPop = 500

const data = load_demography_data(dataPars)

space = DemographicMap("The United Kingdom")
model = DemographicABM(space,pars,simPars,data)
declare_inhabited_towns!(model)
declare_pyramid_population!(model)  # pyramid population
Initialize.init!(model,AgentsModelInit();verify=true)

# Execute ...

debug_setup(model.simPars)

using SocioEconomics.Specification.SimulateNew: dodeaths!, do_assign_guardians!,
    dobirths!, domarriages!,  do_age_transitions!, dodivorces!,
    do_work_transitions!, do_social_transitions!,
    age_transition!, death!, assign_guardian!, marriage!, divorce!,
    work_transition!, social_transition!
using  SocioEconomics.API.Traits: FullPopulation, AlivePopulation


# TODO move to Models?
function agent_steps!(person,model)
    currtime = currenttime(model) + model.simPars.dt # agent_steps is executed first
    age_transition!(person, model)
    divorce!(person, model)
    work_transition!(person, model)
    social_transition!(person, model)
    nothing
end

function model_steps!(model)
    model.t += model.simPars.dt
    currtime = currenttime(model)
    dodeaths!(model)
    do_assign_guardians!(model)
    dobirths!(model,FullPopulation())
    domarriages!(model)
    nothing
end

@time run!(model,agent_steps!,model_steps!,12*30) # run 30 year

@info currenttime(model)
