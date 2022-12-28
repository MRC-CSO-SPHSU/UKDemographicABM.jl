"""
    Main simulation functions for the demographic aspect of LPM. 
""" 

module Simulate

using MultiAgents:  AbstractMABM, AbstractABMSimulator
using MultiAgents:  add_agent!, currstep 
using MALPM.Demography.Population: removeDead!
using MALPM.Demography: DemographyExample, LPMUKDemography, LPMUKDemographyOpt
using SocioEconomics
using SocioEconomics.API.Traits: FullPopulation, NoReturn
import SocioEconomics.Specification.SimulateNew: dodeaths!, dobirths!, 
                        dodivorces!, domarriages!,
                        doAgeTransitions!, doWorkTransitions!, doSocialTransitions!,  
                        doAssignGuardians!
       

function doDeaths!(model::AbstractMABM, sim::AbstractABMSimulator, ::LPMUKDemography) 
    # (; deadsind) = dodeaths!(model,currstep(sim))
    # ToDo separate step? 
    # for ind in Iterators.reverse(deadsind)
    #    removeDead!(ind,model.pop)
    # end
    dodeaths!(model, currstep(sim))
    nothing 
end # function doDeaths!

function doDeaths!(model, sim, ::LPMUKDemographyOpt) 
    dodeaths!(model,currstep(sim),FullPopulation(),NoReturn())
    nothing 
end # function doDeaths!

_dobirths!(model,sim,::LPMUKDemography) = dobirths!(model, currstep(sim))  
_dobirths!(model,sim,::LPMUKDemographyOpt) = 
    dobirths!(model, currstep(sim),FullPopulation(),NoReturn()) 

function doBirths!(model, sim, example)  
    #(;babies) = _dobirths!(model, sim, example) 
    # TODO separate step? 
    # for baby in babies
    #    add_agent!(model.pop,baby)
    #end
    _dobirths!(model, sim, example)
    nothing 
end

_dodivorces!(model,sim,::LPMUKDemography) = dodivorces!(model, currstep(sim))  
_dodivorces!(model,sim,::LPMUKDemographyOpt) = dodivorces!(model, currstep(sim),FullPopulation(), NoReturn()) 

function doDivorces!(model, sim, example) 
    _dodivorces!(model, sim, example) 
    nothing 
end

_domarriages!(model,sim,::LPMUKDemography) = domarriages!(model, currstep(sim))  
_domarriages!(model,sim,::LPMUKDemographyOpt) = domarriages!(model, currstep(sim),FullPopulation(), NoReturn()) 

function doMarriages!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 
    _domarriages!(model, sim,example) 
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