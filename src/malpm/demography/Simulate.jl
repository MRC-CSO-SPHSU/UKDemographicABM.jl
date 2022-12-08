"""
    Main simulation functions for the demographic aspect of LPM. 
""" 

module Simulate

using MultiAgents:  AbstractMABM, AbstractABMSimulation 
using MultiAgents:  add_agent!, currstep 
using MALPM.Demography.Population: removeDead!
using MALPM.Demography: DemographyExample, LPMUKDemography, LPMUKDemographyOpt
using SocioEconomics
import SocioEconomics.Specification.SimulateNew: doDeaths!, doBirths!, doDivorces!, doMarriages!

#alivePeople(model,::LPMUKDemography) = allPeople(model)
#alivePeople(model,::LPMUKDemographyOpt) = alivePeople(model)
       

function removeDeads!(deadpeople,pop,::LPMUKDemography)    
    for deadperson in deadpeople
        removeDead!(deadperson,pop)
    end
    
    nothing 
end

removeDeads!(deadpeople,pop,::LPMUKDemographyOpt) = nothing 

function doDeaths!(model::AbstractMABM, sim::AbstractABMSimulation, example::DemographyExample) # argument simulation or simulation properties ? 

    (deadpeople) = doDeaths!(model,currstep(sim))
    
    # ToDo separate step? 
    removeDeads!(deadpeople,model.pop,example)
    nothing 
end # function doDeaths!

function doBirths!(model::AbstractMABM, sim::AbstractABMSimulation, example::DemographyExample) 

    newbabies = doBirths!(model, currstep(sim)) 

    # false ? population.variables[:numBirths] += length(newbabies) : nothing # Temporarily this way till realized 
    
    for baby in newbabies
        add_agent!(model.pop,baby)
    end

    nothing 
end


function doDivorces!(model::AbstractMABM, sim::AbstractABMSimulation, example::DemographyExample) 

    doDivorces!(model, currstep(sim)) 

    nothing 
end


function doMarriages!(model::AbstractMABM, sim::AbstractABMSimulation, example::DemographyExample) 

    doMarriages!(model, currstep(sim)) 

    nothing 
end




end # Simulate 