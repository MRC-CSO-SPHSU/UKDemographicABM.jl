#using SocioEconomics.XAgents
#using SocioEconomics.ParamTypes: DemographyPars, DemographyData, SimulationPars
include("./modelapi.jl")

using MultiAgents
import MultiAgents: allagents

_alive_people(model) =  [ person for person in all_people(model)  if alive(person) ]

mutable struct MAModel <: AbstractMABM
    const towns  :: Vector{PersonTown}
    const houses :: Vector{PersonHouse}
    const pop :: SimpleABM{Person}
    const parameters :: DemographyPars
    const data :: DemographyData
    t :: Rational{Int}
end

allagents(model::MAModel) = allagents(model.pop)
all_people(model::MAModel) = allagents(model.pop)
alive_people(model::MAModel) = _alive_people(model)
    # Iterators.filter(person->alive(person),people) # Iterators did not show significant value sofar

houses(model::MAModel) = model.houses
towns(model::MAModel) = model.towns

add_person!(model::MAModel, person) = add_agent!(model.pop, person)
remove_person!(model::MAModel, person, personidx::Int) =
    kill_agent_at_opt!(personidx, model.pop)
function add_house!(model::MAModel, house)
    @assert !(house in model.houses)
    push!(model.houses, house)
end
