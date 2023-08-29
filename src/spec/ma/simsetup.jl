using  ABMSim: AbstractABMSimulator
using  ABMSim: attach_pre_model_step!, attach_post_model_step!,
                    attach_agent_step!, currstep
import ABMSim: setup!
#export setup!

function _setup_common!(sim::AbstractABMSimulator)

    debug_setup(sim.parameters)

    attach_pre_model_step!(sim,increment_time!)
    attach_post_model_step!(sim,dodeaths!)
    attach_post_model_step!(sim,do_assign_guardians!)
    attach_post_model_step!(sim,dobirths!)
    attach_post_model_step!(sim,domarriages!)

    nothing
end

#function model_steps!(model,)

"set up simulation functions where dead people are removed"
function setup!(sim::AbstractABMSimulator, example::FullPopEx)
    attach_agent_step!(sim,age_transition_step!)
    attach_agent_step!(sim,divorcestep!)
    attach_agent_step!(sim,work_transition_step!)
    attach_agent_step!(sim,social_transition_step!)
    # attach_agent_step!(sim,marriagestep!) # does not seem to work properly (may be due to memoization)
    _setup_common!(sim)
    nothing
end

function setup!(sim::AbstractABMSimulator,example::AbsAlivePopEx)
    attach_post_model_step!(sim,do_age_transitions!)
    attach_post_model_step!(sim,dodivorces!)
    attach_post_model_step!(sim,do_work_transitions!)
    attach_post_model_step!(sim,do_social_transitions!)
    _setup_common!(sim)
    nothing
end
