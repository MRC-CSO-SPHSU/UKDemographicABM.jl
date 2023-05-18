using Agents
import Agents: add_agent_pos!, add_agent_to_space!, remove_agent_from_space!
include("../modelapi.jl")

#################
# Agents.jl Model
#################

const DemographicABM = ABM{DemographicMap}
mutable struct DemographicProperties
    const parameters :: DemographyPars
    const simPars :: SimulationPars
    const data  :: DemographyData
    t :: Rational{Int}
end
function DemographicABM(space::DemographicMap, pars, simPars, data)
    demoprop = DemographicProperties(pars, simPars, data, simPars.starttime)
    return ABM(Person, space; properties = demoprop)
end

towns(model::DemographicABM) = model.space.towns
function houses(model::DemographicABM)
    @warn "using houses(::$(typeof(model)) is not efficient"
    houses = PersonHouse[]
    for town in model.space.towns
        houses = vcat(houses, empty_houses(town), occupied_houses(town))
    end
    return houses
end

all_people(model::DemographicABM) = collect(Agents.allagents(model)) # TODO Is there something better
#all_people(model::DemographicABM) = Agents.allagents(model) # TODO Is there something better
alive_people(model::DemographicABM) = all_people(model) #_alive_people(model)

add_person!(model::DemographicABM,person) = add_agent_pos!(person, model)
# The following is needed by add_agent[_pos]!(agent,model)
function add_agent_to_space!(person, model::DemographicABM)
    @assert ishomeless(person) ||  home(person) in occupied_houses(hometown(person))
    @assert undefined(hometown(person)) || hometown(person) in towns(model)
end

function remove_person!(model::DemographicABM, person, personidx::Int)
    kill_agent!(person,model)
end
# The following is needed by kill_agent!
function remove_agent_from_space!(person, model::DemographicABM)
    @assert undefined(person.pos)
end

function add_house!(model::DemographicABM, house)
    @assert house in town(house).emptyHouses || house in town(house).occupiedHouses
    nothing # already added add_empty_house!(town(house), house)
end
