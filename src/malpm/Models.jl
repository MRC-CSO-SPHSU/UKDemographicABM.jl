"""
This module is defining simulation models

This module is within the MALPM module
"""

module Models

using Agents

using SocioEconomics.XAgents
using SocioEconomics.ParamTypes: DemographyPars, DemographyData

using MultiAgents: AbstractMABM, SimpleABM
using MultiAgents: allagents, add_agent!, kill_agent_at_opt!

import MultiAgents: add_agent_pos!, add_agent_to_space!, nagents, allagents, remove_agent_from_space!
import SocioEconomics.API.ParamFunc: all_pars, population_pars, birth_pars, divorce_pars,
    marriage_pars, work_pars, map_pars
import SocioEconomics.API.ModelFunc: all_people, alive_people,
    data_of, houses, towns,
    add_person!, add_house!, remove_person!

export MAModel
export DemographicABM

_alive_people(model) =  [ person for person in all_people(model)  if alive(person) ]

struct MAModel <: AbstractMABM
    towns  :: Vector{PersonTown}
    houses :: Vector{PersonHouse}
    pop    :: SimpleABM{Person}
    parameters :: DemographyPars
    data       :: DemographyData
end

allagents(model::MAModel) = allagents(model.pop)
all_people(model::MAModel) = allagents(model.pop)
alive_people(model::MAModel) = _alive_people(model)

    # Iterators.filter(person->alive(person),people) # Iterators did not show significant value sofar
houses(model::MAModel) = model.houses
towns(model::MAModel) = model.towns
data_of(model) = model.data
add_person!(model::MAModel, person) = add_agent!(model.pop, person)
remove_person!(model::MAModel, person, personidx::Int) =
    kill_agent_at_opt!(personidx, model.pop)
add_house!(model, house) = push!(model.houses, house)

all_pars(model::MAModel) = model.parameters
population_pars(model::MAModel) = model.parameters.poppars
birth_pars(model::MAModel)	 	 = model.parameters.birthpars
divorce_pars(model::MAModel)    = model.parameters.divorcepars
marriage_pars(model::MAModel)   = model.parameters.marriagepars
work_pars(model::MAModel)       = model.parameters.workpars
map_pars(model::MAModel)        = model.parameters.mappars

#################
# Agents.jl Model
#################

const DemographicABM = ABM{DemographicMap}
DemographicABM(space::DemographicMap, pars, simPars, data) =
    ABM(Person, space; properties = (pars = pars, simPars = simPars, data = data))
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

all_pars(model::DemographicABM) =  model.pars
population_pars(model::DemographicABM) = model.pars.poppars
birth_pars(model::DemographicABM) = model.pars.birthpars
divorce_pars(model::DemographicABM) = model.pars.divorcepars
marriage_pars(model::DemographicABM) = model.pars.marriagepars
work_pars(model::DemographicABM) = model.pars.workpars
map_pars(model::DemographicABM) = model.pars.mappars

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


end # module Models
