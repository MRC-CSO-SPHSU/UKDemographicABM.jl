"""
Population module providing help utilities for realizing a population as an ABM
"""

module Population 

using  MultiAgents: SimpleABM, AbstractABMSimulator, AbstractMABM  
using  MultiAgents: allagents, dt, kill_agent!, kill_agent_opt!,
                        kill_agent_at!, kill_agent_at_opt!
using  SocioEconomics.XAgents: Person 
using  SocioEconomics.XAgents: alive, agestepAlive! 

import SocioEconomics.XAgents: agestep!

export population_step!, agestepAlivePerson!, removeDead!
export PopulationType 

const PopulationType = SimpleABM{Person}

"Step function for the population"
function population_step!(population::PopulationType,
                            sim::AbstractABMSimulator, 
                            example) 
    for person in allagents(population)
        if alive(person) 
            agestep!(person,dt(sim)) 
        end  
    end
end 

population_step!(model::AbstractMABM,
                            sim::AbstractABMSimulator, 
                            example) =
    population_step!(model.pop,sim,example)

"remove dead persons" 
function removeDead!(person::Person, population::PopulationType) 
    @assert alive(person)
    kill_agent_opt!(person, population) 
    nothing 
end

function removeDead!(idx::Int, population::PopulationType) 
    kill_agent_at_opt!(idx, population)  
    nothing 
end

function removeDead!(population::PopulationType,
                        ::AbstractABMSimulator,
                        example) 
    people = reverse(allagents(population))
    for person in people 
        alive(person) ? nothing : kill_agent!(person,population)
    end 
    nothing
end

"increment age with the simulation step size"
agestep!(person::Person,
            population::PopulationType,
            sim::AbstractABMSimulator,
            example) = agestep!(person,dt(sim))


agestep!(person::Person,model::AbstractMABM,sim,example) = 
    agestep!(person,model.pop,sim,example)

"increment age with the simulation step size"
agestepAlivePerson!(person::Person, population::PopulationType,
                        sim::AbstractABMSimulator,
                        example)  = 
                            agestepAlive!(person, dt(sim))


agestepAlivePerson!(person,model::AbstractMABM,sim,example) =
    agestepAlivePerson!(person,model.pop,sim,example)                              

end # Population 



