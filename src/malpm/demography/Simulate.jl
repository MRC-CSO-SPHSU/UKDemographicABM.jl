"""
    Main simulation functions for the demographic aspect of LPM. 
""" 

module Simulate

using MultiAgents:  AbstractMABM, AbstractABMSimulator
using MultiAgents:  add_agent!, currstep 
using MALPM.Demography.Population: removeDead!
using MALPM.Demography: DemographyExample, LPMUKDemography, LPMUKDemographyOpt
using SocioEconomics
using SocioEconomics.XAgents: Person
using SocioEconomics.API.Traits: FullPopulation, SimProcess, Death, Birth, Marriage, AssignGuardian 
using SocioEconomics.Utilities: date2yearsmonths
import SocioEconomics.Specification.SimulateNew: dodeaths!, dobirths!, 
                        dodivorces!, domarriages!, do_assign_guardians!,
                        doAgeTransitions!, doWorkTransitions!, doSocialTransitions!

const retDeath = Person[]
_init_return(::LPMUKDemographyOpt,::SimProcess) = 0
_init_return(::LPMUKDemography,::Death) = retDeath 

_dodeaths!(ret,model,time,::LPMUKDemography) = dodeaths!(model,time,FullPopulation(),ret) 
_dodeaths!(ret,model,time,::LPMUKDemographyOpt) = dodeaths!(model,time,ret) 

function doDeaths!(model, sim, example) 
    ret = _init_return(example,Death())
    ret = _dodeaths!(ret, model, currstep(sim), example)
    #=years, months = date2yearsmonths(currstep(sim))
    @info "# of deaths $(years) $(months+1) : $(length(ret.people))"=#
    nothing 
end # function doDeaths!

const retBirth = Person[]
_init_return(::LPMUKDemography,::Birth) = retBirth 

_dobirths!(ret,model,sim,::LPMUKDemographyOpt) = dobirths!(model, currstep(sim), ret)  
_dobirths!(ret,model,sim,::LPMUKDemography) = 
    dobirths!(model, currstep(sim), FullPopulation(),ret) 

function doBirths!(model, sim, example)  
    ret = _init_return(example,Birth())
    ret = _dobirths!(ret,model, sim, example)
    nothing 
end

const retBirth = Person[] 
_init_return(::LPMUKDemography,::Birth) = retBirth 

_dodivorces!(ret,model,sim,::LPMUKDemographyOpt) = dodivorces!(model, currstep(sim), ret)  
_dodivorces!(ret,model,sim,::LPMUKDemography) = dodivorces!(model, currstep(sim),FullPopulation(),ret) 

function doDivorces!(model, sim, example) 
    ret = _init_return(example, Birth())
    ret = _dodivorces!(ret, model, sim, example) 
    nothing 
end

_domarriages!(ret,model,sim,::LPMUKDemographyOpt) = domarriages!(model, currstep(sim))  
_domarriages!(ret,model,sim,::LPMUKDemography) = domarriages!(model, currstep(sim),FullPopulation(), ret) 

const retMarriage = Person[] 
_init_return(::LPMUKDemography,::Marriage) = retMarriage 

function doMarriages!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 
    ret = _init_return(example, Marriage())
    _domarriages!(ret,model, sim,example) 
    nothing 
end

_do_assign_guardians!(ret,model,sim,::LPMUKDemographyOpt) = 
    do_assign_guardians!(model, currstep(sim), ret)  
_do_assign_guardians!(ret,model,sim,::LPMUKDemography) = 
    do_assign_guardians!(model, currstep(sim), FullPopulation(), ret) 

const retAGuarians = Person[] 
_init_return(::LPMUKDemography,::AssignGuardian) = retAGuarians 

function doAssignGuardians!(model::AbstractMABM, sim::AbstractABMSimulator, example::DemographyExample) 
    ret = _init_return(example, AssignGuardian())
    _do_assign_guardians!(ret,model,sim,example)
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