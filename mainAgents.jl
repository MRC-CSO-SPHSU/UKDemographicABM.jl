"""
A demographic-ABM simulation of the UK using Agents.jl package
"""

include("src/agentsjlspec.jl")

using Agents

const simPars, dataPars, pars = load_parameters()
# significant parameters
simPars.seed = 0; ParamTypes.seed!(simPars)
simPars.verbose = false
simPars.checkassumption = false
simPars.sleeptime = 0
pars.poppars.initialPop = 5000

const data = load_demography_data(dataPars)

space = DemographicMap("The United Kingdom")
model = DemographicABM(space,pars,simPars,data)
declare_inhabited_towns!(model)
declare_pyramid_population!(model)  # pyramid population
Initialize.init!(model,AgentsModelInit();verify=false)

# Execute ...

debug_setup(simPars)

const pf = AlivePopulation()

# TODO move to Models?
function agent_steps!(person,model)
    age_transition!(person, model, pf)
    divorce!(person, model, pf)
    work_transition!(person, model, pf)
    social_transition!(person, model, pf)
    nothing
end

function model_steps!(model)
    model.t += simPars.dt
    dodeaths!(model,pf)
    do_assign_guardians!(model,pf)
    dobirths!(model,FullPopulation())
    domarriages!(model,pf)
    nothing
end

#const adata = []
#const mdata = [currenttime]
@time run!(model,agent_steps!,model_steps!,12*100) #;adata,mdata) # run 10 year

@info currenttime(model)
