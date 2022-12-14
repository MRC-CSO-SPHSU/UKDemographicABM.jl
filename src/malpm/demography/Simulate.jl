"""
    Main simulation functions for the demographic aspect of LPM. 
""" 

module Simulate

using MultiAgents:  AbstractMABM, AbstractABMSimulator
using MultiAgents:  add_agent!, currstep 
using MALPM.Demography.Population: removeDead!
using MALPM.Demography: DemographyExample, LPMUKDemography, LPMUKDemographyOpt
using SocioEconomics
import SocioEconomics.Specification.SimulateNew: doDeaths!, doBirths!, 
                        doAgeTransitions!, doWorkTransitions!, doSocialTransitions!,  
                        doDivorces!, doMarriages!, doAssignGuardians!
       
"""
dead people could be indicies in the population and in such a 
    case it is assumed that these indices are ordered
"""
function removeDeads!(deadpeople,pop,::LPMUKDemography)    
    for deadperson in Iterators.reverse(deadpeople)
        removeDead!(deadperson,pop)
    end
    
    nothing 
end

removeDeads!(deadpeople,pop,::LPMUKDemographyOpt) = nothing 

function doDeaths!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 
    #(deadpeople, deadsind) = doDeaths!(model,currstep(sim))
    (; deadsind) = doDeaths!(model,currstep(sim))
    
    #len = length(model.pop.agentsList)
    #@info deadsind len 

    # ToDo separate step? 
    # removeDeads!(deads,model.pop,example)
    removeDeads!(deadsind,model.pop,example)

    nothing 
end # function doDeaths!

function doBirths!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 

    newbabies = doBirths!(model, currstep(sim)) 

    # false ? population.variables[:numBirths] += length(newbabies) : nothing # Temporarily this way till realized 
    
    for baby in newbabies
        add_agent!(model.pop,baby)
    end

    nothing 
end


function doDivorces!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 

    doDivorces!(model, currstep(sim)) 

    nothing 
end


function doMarriages!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 

    doMarriages!(model, currstep(sim)) 

    nothing 
end


function doAssignGuardians!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 

    doAssignGuardians!(model, currstep(sim)) 

    nothing 
end


function doAgeTransitions!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 

    doAgeTransitions!(model, currstep(sim)) 

    nothing 
end

function doWorkTransitions!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 

    doWorkTransitions!(model, currstep(sim)) 

    nothing 
end

function doSocialTransitions!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 

    doSocialTransitions!(model, currstep(sim)) 

    nothing 
end





end # Simulate 