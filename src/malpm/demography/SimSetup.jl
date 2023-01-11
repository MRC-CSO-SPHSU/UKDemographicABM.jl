module SimSetup

using Memoization 
using MALPM.Demography.Population: removeDead!, 
                agestepAlivePerson!, agestep!, population_step!

using  MALPM.Models: MAModel, allPeople, birthParameters
using  MALPM.Demography: DemographyExample, 
                            LPMUKDemography, LPMUKDemographyOpt
using  MALPM.Demography.Simulate: doDeaths!, doBirths!, 
                                    doAgeTransitions!, doWorkTransitions!, doSocialTransitions!, 
                                    doDivorces!, doMarriages!, doAssignGuardians!

using  MultiAgents: AbstractABMSimulator
using  MultiAgents: attach_pre_model_step!, attach_post_model_step!, 
                    attach_agent_step!, currstep 
using  SocioEconomics.Utilities: setVerbose!, unsetVerbose!, setDelay!,
                    checkAssumptions!, ignoreAssumptions!, date2yearsmonths
using  SocioEconomics.XAgents: age, isMale, isFemale, isSingle, alive, hasDependents
using  SocioEconomics.API.Traits: FullPopulation, AlivePopulation
using  SocioEconomics.Specification.SimulateNew: death!, birth!, divorce!, marriage!, 
                    assign_guardian!, age_transition!, work_transition!, social_transition!

import SocioEconomics.API.ModelFunc: share_childless_men, eligible_women
import MultiAgents: setup!, verbose
export setup!  

function setupCommon!(sim::AbstractABMSimulator) 

    verbose(sim) ? setVerbose!() : unsetVerbose!()
    setDelay!(sim.parameters.sleeptime)
    sim.parameters.checkassumption ? checkAssumptions!() :
                                        ignoreAssumptions!()
    
    attach_post_model_step!(sim,doDeaths!)
    attach_post_model_step!(sim,doAssignGuardians!)
    attach_post_model_step!(sim,doBirths!)
    attach_post_model_step!(sim,doMarriages!)
   
    nothing 
end 

_popfeature(::LPMUKDemography) = FullPopulation() 
_popfeature(::LPMUKDemographyOpt) = AlivePopulation() 

deathstep!(person, model, sim, example) = 
    death!(person, currstep(sim),model,_popfeature(example))

birthstep!(person, model, sim, example) = 
    birth!(person, currstep(sim),model,_popfeature(example))
    
divorcestep!(person, model, sim, example) = 
    divorce!(person, currstep(sim), model, _popfeature(example))

marriagestep!(person, model, sim, example) = 
    marriage!(person, currstep(sim), model, _popfeature(example))

assign_guardian_step!(person, model, sim, example) = 
    assign_guardian!(person, currstep(sim), model, _popfeature(example))

age_transition_step!(person, model, sim, example) = 
    age_transition!(person, currstep(sim), model, _popfeature(example))

work_transition_step!(person, model, sim, example) = 
    work_transition!(person, currstep(sim), model, _popfeature(example))

social_transition_step!(person, model, sim, example) = 
    social_transition!(person, currstep(sim), model, _popfeature(example))

_ageclass(person) = trunc(Int, age(person)/10)
@memoize Dict function share_childless_men(model::MAModel, ageclass :: Int)
    nAll = 0
    nNoC = 0
    for p in Iterators.filter(x->alive(x) && isMale(x) && _ageclass(x) == ageclass, allPeople(model))
        nAll += 1
        if !hasDependents(p)
            nNoC += 1
        end
    end
    return nNoC / nAll
end

@memoize eligible_women(model::MAModel) = 
    [f for f in allPeople(model) if isFemale(f) && alive(f) &&
        isSingle(f) && age(f) > birthParameters(model).minPregnancyAge]

function reset_cache_marriages(model,sim,::LPMUKDemography)
    #@info "cache reset at $(date2yearsmonths(currstep(sim)))"
    Memoization.empty_cache!(share_childless_men)
    Memoization.empty_cache!(eligible_women)
end

"set up simulation functions where dead people are removed" 
function setup!(sim::AbstractABMSimulator, example::LPMUKDemography)
    # attach_pre_model_step!(sim,population_step!)
    # attach_pre_model_step!(sim,reset_cache_marriages)
    #attach_agent_step!(sim,agestepAlivePerson!)
    # attach_agent_step!(sim,deathstep!) this leads to excessive memory allocation and memory storage
    # attach_agent_step!(sim,birthstep!) this leads to excessive memory allocation and memory storage
    #attach_agent_step!(sim,assign_guardian_step!)
    attach_agent_step!(sim,age_transition_step!)
    attach_agent_step!(sim,divorcestep!)
    attach_agent_step!(sim,work_transition_step!)
    attach_agent_step!(sim,social_transition_step!)
    # attach_agent_step!(sim,marriagestep!) # does not seem to work properly (may be due to memoization)
    setupCommon!(sim)
    nothing 
end

function setup!(sim::AbstractABMSimulator,example::LPMUKDemographyOpt) 
    #attach_agent_step!(sim,agestep!)
    #attach_agent_step!(sim,age_transition_step!)
    #attach_post_model_step!(sim,doAssignGuardians!)
    attach_post_model_step!(sim,doAgeTransitions!)
    attach_post_model_step!(sim,doDivorces!)
    attach_post_model_step!(sim,doWorkTransitions!)
    attach_post_model_step!(sim,doSocialTransitions!)
    setupCommon!(sim)
    nothing 
end

end # SimSetup 