"""
Population module providing help utilities for realizing a population as an ABM
"""

module Population 

using  MultiAgents: ABM, AbstractABMSimulation, AbstractMABM  
using  MultiAgents: allagents, dt, kill_agent!, kill_agent_opt!,
                        kill_agent_at!, kill_agent_at_opt!
using  SocioEconomics.XAgents: Person 
using  SocioEconomics.XAgents: alive, agestepAlive! 
# using  MALPM.Demography: population

import SocioEconomics.XAgents: agestep!

export population_step!, agestepAlivePerson!, removeDead!


"Step function for the population"
function population_step!(population::ABM{PersonType},
                            sim::AbstractABMSimulation, 
                            example) where {PersonType} 
    for person in allagents(population)
        if alive(person) 
            agestep!(person,dt(sim)) 
        end  
    end
end 

population_step!(model::AbstractMABM,
                            sim::AbstractABMSimulation, 
                            example) =
    population_step!(model.pop,sim,example)

"remove dead persons" 
function removeDead!(person::PersonType, population::ABM{PersonType}) where {PersonType} 
    @assert alive(person)
    kill_agent_opt!(person, population) 
    nothing 
end

function removeDead!(idx::Int, population::ABM{PersonType}) where {PersonType} 
    kill_agent_at_opt!(idx, population)  
    nothing 
end

function removeDead!(population::ABM{PersonType},
                        simulation::AbstractABMSimulation,
                        example) where {PersonType} 
    people = reverse(allagents(population))
    for person in people 
        alive(person) ? nothing : kill_agent!(person,population)
    end 
    nothing
end

"increment age with the simulation step size"
agestep!(person::Person,population::ABM{Person},
            sim::AbstractABMSimulation,
            example) where {PersonType} = agestep!(person,dt(sim))


agestep!(person::Person,model::AbstractMABM,sim,example) = 
    agestep!(person,model.pop,sim,example)

"increment age with the simulation step size"
agestepAlivePerson!(person::PersonType,population::ABM{PersonType},
                        sim::AbstractABMSimulation,
                        example) where {PersonType} = 
                            agestepAlive!(person, dt(sim))


agestepAlivePerson!(person,model::AbstractMABM,sim,example) =
    agestepAlivePerson!(person,model.pop,sim,example)                              

end # Population 



