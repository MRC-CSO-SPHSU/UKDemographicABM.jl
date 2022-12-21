module SimSetup


using MALPM.Demography.Population: removeDead!, 
                agestepAlivePerson!, agestep!, population_step!

using  MALPM.Demography: DemographyExample, 
                            LPMUKDemography, LPMUKDemographyOpt
using  MALPM.Demography.Simulate: doDeaths!, doBirths!, 
                                    doAgeTransitions!, doWorkTransitions!, doSocialTransitions!, 
                                    doDivorces!, doMarriages!, doAssignGuardians!

using  MultiAgents: AbstractABMSimulator
using  MultiAgents: attach_pre_model_step!, attach_post_model_step!, 
                    attach_agent_step!
using  SocioEconomics.Utilities: setVerbose!, unsetVerbose!, setDelay!,
                    checkAssumptions!, ignoreAssumptions!
import MultiAgents: setup!, verbose
export setup!  

"""
set simulation paramters @return dictionary of symbols to values

All information needed by the generic Simulators.run! function
is provided here

@return dictionary of required simulation parameters 
"""


function setupCommon!(sim::AbstractABMSimulator) 

    verbose(sim) ? setVerbose!() : unsetVerbose!()
    setDelay!(sim.parameters.sleeptime)
    sim.parameters.checkassumption ? checkAssumptions!() :
                                        ignoreAssumptions!()

    attach_post_model_step!(sim,doDeaths!)
    attach_post_model_step!(sim,doAssignGuardians!)
    attach_post_model_step!(sim,doBirths!)
    attach_post_model_step!(sim,doAgeTransitions!)
    attach_post_model_step!(sim,doWorkTransitions!)
    attach_post_model_step!(sim,doSocialTransitions!)
    attach_post_model_step!(sim,doDivorces!)
    attach_post_model_step!(sim,doMarriages!)
    nothing 
end 

"set up simulation functions where dead people are removed" 
function setup!(sim::AbstractABMSimulator, example::LPMUKDemography)
    # attach_pre_model_step!(sim,population_step!)
    # attach_agent_step!(sim,agestep!)
    setupCommon!(sim)

    nothing 
end


function setup!(sim::AbstractABMSimulator,example::LPMUKDemographyOpt) 

    # attach_agent_step!(sim,agestepAlivePerson!)
    setupCommon!(sim)

    nothing 
end


end # SimSetup 