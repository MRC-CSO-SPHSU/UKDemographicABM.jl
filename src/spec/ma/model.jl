include("../modelapi.jl")

using ABMSim: SimpleABM, AbstractMABM, add_agent!, kill_agent_at_opt!
import ABMSim: allagents
import ABMSim.Util: AbstractExample
export  AbsExample, FullPopEx, AbsAlivePopEx

### Example Names
"Super type for all demographic models"
abstract type AbsExample <: AbstractExample end

"This corresponds to simulation with full population without deads removal"
struct FullPopEx <: AbsExample end

"With deads removal"
abstract type AbsAlivePopEx <: AbsExample end

struct AlivePopEx <: AbsAlivePopEx end

"Simulation with a simple simulator type"
struct SimpleSimulatorEx <: AbsAlivePopEx end

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

add_person!(model::MAModel, person) = add_agent!(model.pop, person)
remove_person!(model::MAModel, person, personidx::Int) =
    kill_agent_at_opt!(personidx, model.pop)
function add_house!(model::MAModel, house)
    @assert !(house in model.houses)
    push!(model.houses, house)
end
